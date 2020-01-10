package server;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MySocketServer {


    private boolean isEnable;
    private final WebConfig webConfig;//配置信息类
    private final ExecutorService threadPool;//线程池
    private ServerSocket socket;
    private JsonUtil jsonUtil;
    private ServerMsgCallback serverMsgCallback;
    private Socket remotePeer;

    public MySocketServer(WebConfig webConfig,ServerMsgCallback callback) {
        this.webConfig = webConfig;
        threadPool = Executors.newCachedThreadPool();
        jsonUtil = new JsonUtil();
        serverMsgCallback = callback;
    }

    /**
     * 开启server
     */
    public void startServerAsync() {
        isEnable=true;
        new Thread(new Runnable() {
            @Override
            public void run() {
                doProcSync();
            }
        }).start();
    }

    /**
     * 关闭server
     */
    public void stopServerAsync() throws IOException {
        if (!isEnable){
            return;
        }
        isEnable=true;
        socket.close();
        socket=null;
    }

    private void doProcSync() {
        try {
            InetSocketAddress socketAddress=new InetSocketAddress(webConfig.getPort());
            socket=new ServerSocket();
            socket.bind(socketAddress);
            Log.e("server","local..............."+socketAddress.getHostName());
            while (isEnable){
                remotePeer= socket.accept();
                threadPool.submit(new Runnable() {
                    @Override
                    public void run() {
                        Log.e("server","remotePeer..............."+remotePeer.getRemoteSocketAddress().toString());
                        onAcceptRemotePeer(remotePeer);
                    }
                });
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void onAcceptRemotePeer(Socket remotePeer) {
        try {
            if (serverMsgCallback!=null){
                mHandler.sendEmptyMessage(0);

            }

            // 从Socket当中得到InputStream对象
            InputStream inputStream = remotePeer.getInputStream();
            byte buffer[] = new byte[1024 * 4];
            int temp = 0;
            // 从InputStream当中读取客户端所发送的数据
            while ((temp = inputStream.read(buffer)) != -1) {
                Log.e("server",new String(buffer, 0, temp, "UTF-8"));
                String data = new String(buffer, 0, temp, "UTF-8");
                receivedata(remotePeer,data);
            }
        } catch (Exception e) {
            Log.e("server","servererror="+e.toString());
            e.printStackTrace();
        }

    }

    private void receivedata(Socket remotePeer, String data){
        if (serverMsgCallback!=null){
            Message msg = new Message();
            msg.what = 1;
            msg.obj  = data;
            mHandler.sendMessage(msg);
        }
    }

    public void writedata(String data){
        try {
            threadPool.submit(new Runnable() {
                @Override
                public void run() {
                    try {
                        remotePeer.getOutputStream().write(data.getBytes());
                    }catch (Exception e){
                    }

                }
            });

        }
        catch (Exception e){
        }
    }

    private android.os.Handler mHandler = new Handler() {

        public void handleMessage(Message msg) {
            if (msg.what==0){
                serverMsgCallback.msgreceived("connect success");
            }
            else if (msg.what==1){
                String data = (String) msg.obj;
                serverMsgCallback.msgreceived(data);
            }
        }
    };
}
