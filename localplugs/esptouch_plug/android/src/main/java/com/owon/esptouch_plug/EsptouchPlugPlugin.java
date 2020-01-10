package com.owon.esptouch_plug;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import esptouch.IEsptouchListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import esptouch.EsptouchTask;
import esptouch.IEsptouchResult;
import esptouch.IEsptouchTask;
import esptouch.util.ByteUtil;
import esptouch.util.TouchNetUtil;
import server.MySocketServer;
import server.ServerMsgCallback;
import server.WebConfig;

/** EsptouchPlugPlugin */
public class EsptouchPlugPlugin implements FlutterPlugin, MethodCallHandler , ServerMsgCallback {
  static Context context;
  private EsptouchAsyncTask4 mTask;
  private MySocketServer mySocketServer;
  private static EventChannel.EventSink meventSink;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "esptouch_plug");
    channel.setMethodCallHandler(new EsptouchPlugPlugin());
    context = flutterPluginBinding.getApplicationContext();
    final EventChannel eventChannel = new EventChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "esptouch_plugin_event");
    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object o, EventChannel.EventSink eventSink) {
        meventSink = eventSink;
      }

      @Override
      public void onCancel(Object o) {
        meventSink = null;
      }
    });
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "esptouch_plug");
    channel.setMethodCallHandler(new EsptouchPlugPlugin());
    context = registrar.context();
    final EventChannel eventChannel = new EventChannel(registrar.messenger(), "esptouch_plugin_event");
    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object o, EventChannel.EventSink eventSink) {
        meventSink = eventSink;
      }

      @Override
      public void onCancel(Object o) {
        meventSink = null;
      }
    });

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (mySocketServer == null){
      Log.e("serverlog","openlocalserver");
      WebConfig webConfig = new WebConfig();
      webConfig.setPort(1024);
      webConfig.setMaxParallels(10);
      mySocketServer = new MySocketServer(webConfig,this);
    }
    if (call.method.equals("espTouchConfig")) {
      Map map = (Map) call.arguments;
      //result.success("Androidx" + android.os.Build.VERSION.RELEASE + "xxx" + map.get("username"));
      byte[] ssid = ByteUtil.getBytesByString((String)map.get("ssid"));
      byte[] password = ByteUtil.getBytesByString((String)map.get("password"));
      byte[] bssid = TouchNetUtil.parseBssid2bytes((String)map.get("bssid"));
      byte[] deviceCount = "1".getBytes();
      byte[] broadcast ={(byte)0};
      mTask = new EsptouchAsyncTask4();
      mTask.execute(ssid, bssid, password, deviceCount, broadcast);
      Log.e("server","msg="+map.get("ssid")+map.get("password")+map.get("bssid"));
    }
    else if(call.method.equals("openLocalServer")){
      try {
        mySocketServer.startServerAsync();
        result.success("openLocalServer");
      }catch (Exception e){

      }
    }
    else if(call.method.equals("closeLocalServer")){
      try {
        mySocketServer.stopServerAsync();
        mySocketServer=null;
        Log.e("serverlog","closelocalserver "+mySocketServer);
        result.success("stopServerAsync");
      }catch (Exception e){

      }

    }
    else if(call.method.equals("writeData")){
      Map map = (Map) call.arguments;
      String data = (String)map.get("data");
      try {
        mySocketServer.writedata(data);
        result.success("writeData");
      }catch (Exception e){
      }
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }



  private  class EsptouchAsyncTask4 extends AsyncTask<byte[], IEsptouchResult, List<IEsptouchResult>> {


    private final Object mLock = new Object();
    private IEsptouchTask mEsptouchTask;



    @Override
    protected void onPreExecute() {

    }

    @Override
    protected void onProgressUpdate(IEsptouchResult... values) {
      IEsptouchResult result = values[0];
    }


    @Override
    protected List<IEsptouchResult> doInBackground(byte[]... params) {

      int taskResultCount;
      synchronized (mLock) {
        byte[] apSsid = params[0];
        byte[] apBssid = params[1];
        byte[] apPassword = params[2];
        byte[] deviceCountData = params[3];
        byte[] broadcastData = params[4];
        taskResultCount = deviceCountData.length == 0 ? -1 : Integer.parseInt(new String(deviceCountData));

        mEsptouchTask = new EsptouchTask(apSsid, apBssid, apPassword, context);
        mEsptouchTask.setPackageBroadcast(broadcastData[0] == 1);
        mEsptouchTask.setEsptouchListener(this::publishProgress);
      }
      return mEsptouchTask.executeForResults(taskResultCount);
    }

    @Override
    protected void onPostExecute(List<IEsptouchResult> result) {

      if (result == null) {

        return;
      }

      // check whether the task is cancelled and no results received
      IEsptouchResult firstResult = result.get(0);
      if (firstResult.isCancelled()) {
        return;
      }
      // the task received some results including cancelled while
      // executing before receiving enough results

      if (!firstResult.isSuc()) {

        return;
      }

      ArrayList<CharSequence> resultMsgList = new ArrayList<>(result.size());
      for (IEsptouchResult touchResult : result) {

      }
      CharSequence[] items = new CharSequence[resultMsgList.size()];

    }
  }

  @Override
  public void msgreceived(String msg) {
        meventSink.success(msg);
  }
}
