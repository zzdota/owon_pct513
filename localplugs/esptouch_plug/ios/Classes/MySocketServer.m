//
//  MySocketServer.m
//  EspTouchDemo
//
//  Created by 洪翔 on 2019/11/20.
//  Copyright © 2019 Espressif. All rights reserved.
//

#import "MySocketServer.h"
#import "GCDAsyncSocket.h"

@interface MySocketServer()<GCDAsyncSocketDelegate>


@property (nonatomic,strong) GCDAsyncSocket *socket;

@property (nonatomic,strong) GCDAsyncSocket *client;

@end
@implementation MySocketServer
//创建服务端的单例
+ (instancetype)sharedServer
{
    static dispatch_once_t onceToken;
    static MySocketServer *server;
    dispatch_once(&onceToken, ^{
        server = [[MySocketServer alloc] init];
//初始化服务器
        [server initServer];
    });
    return server;
}
- (void)initServer
{
//创建socket对象
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    
   
}
//调用startServer用来启动socket服务器
- (void)startServer:(int)port
{
    NSError *err = nil;
//这里的kPort是一个宏定义，写的时候可以根据自己的需要定义一个端口用来监听
    [_socket acceptOnPort:port error:&err];
    if (err)
    {
        NSLog(@"服务器启动失败%@",err);
    }else{
        NSLog(@"服务器启动成功,正在监听%d端口",port);
    }
}
- (void)sendData:(NSData *)data toClient:(GCDAsyncSocket *)sock
{
    [sock writeData:data withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    //这里要注意，对于连接到服务器的客户端socket必须进行持有，否则客户端会出现连接上就断开的情况
    _client = newSocket;
    if (_delegate!=nil) {
        [_delegate didReceiveData:@"connect success"];
    }
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{

   
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSData *tempData = [self UTF8Data:data];
    NSString *str = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    if (_delegate!=nil) {
        [_delegate didReceiveData:str];
    }
    
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"服务端发送消息成功");
    [_client readDataWithTimeout:-1 tag:0];
}

-(NSData *)transformData: (id)data{
    unsigned int str1=2;
    unsigned int str2=3;
    char s1=(char)str1;
    char s2=(char)str2;
    
    NSString * requestString;
    
    if ([data isKindOfClass:[NSData class]]) {
        return data;
    }else if ([data isKindOfClass:[NSString class]]) {
        requestString =[NSString stringWithFormat:@"%c%@%c",s1,data,s2];
    }else if ([data isKindOfClass:[NSDictionary class]]){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        requestString =[NSString stringWithFormat:@"%c%@%c",s1,str,s2];
    }
    
    //    NSLog(@"------------------->>>>>>>>>%@", requestString);
    
    NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
    return requestData;
}

- (NSData *)UTF8Data:(NSData *)data
{
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:data.length];
    
    //无效编码替代符号(常见 � □ ?)
    NSData *replacement = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = data.bytes;
    
    while (index < data.length)
    {
        uint8_t len = 0;
        uint8_t header = bytes[index];
        
        //单字节
        if ((header&0x80) == 0)
        {
            len = 1;
        }
        //2字节(并且不能为C0,C1)
        else if ((header&0xE0) == 0xC0)
        {
            if (header != 0xC0 && header != 0xC1)
            {
                len = 2;
            }
        }
        //3字节
        else if((header&0xF0) == 0xE0)
        {
            len = 3;
        }
        //4字节(并且不能为F5,F6,F7)
        else if ((header&0xF8) == 0xF0)
        {
            if (header != 0xF5 && header != 0xF6 && header != 0xF7)
            {
                len = 4;
            }
        }
        
        //无法识别
        if (len == 0)
        {
//            [WSProgressHUD showImage:nil status:@"非法字符"maskType:(WSProgressHUDMaskTypeClear)];
            
            [resData appendData:replacement];
            index++;
            continue;
        }
        
        //检测有效的数据长度(后面还有多少个10xxxxxx这样的字节)
        uint8_t validLen = 1;
        while (validLen < len && index+validLen < data.length)
        {
            if ((bytes[index+validLen] & 0xC0) != 0x80)
                break;
            validLen++;
        }
        
        //有效字节等于编码要求的字节数表示合法,否则不合法
        if (validLen == len)
        {
            [resData appendBytes:bytes+index length:len];
        }else
        {
            [resData appendData:replacement];
        }
        
        //移动下标
        index += validLen;
    }
    
    return resData;
}

-(void)writeData:(NSString *)data{
    [self sendData:[self transformData:data] toClient:_client];
}

- (void)stopServer{
    if (_socket!=nil) {
        [_socket disconnect];
    }
}
@end

