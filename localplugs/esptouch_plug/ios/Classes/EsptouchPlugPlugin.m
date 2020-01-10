#import "EsptouchPlugPlugin.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import "ESPAES.h"
#import "ESPTools.h"
#import "MySocketServer.h"

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate,MySocketServerDelegate>


@end

@implementation EspTouchDelegateImpl

-(void) dismissAlert:(UIAlertView *)alertView
{
   // [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

-(void) showAlertWithResult: (ESPTouchResult *) result
{
  //  NSString *title = nil;
  //  NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
  //  NSTimeInterval dismissSeconds = 3.5;
  //  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
  //  [alertView show];
  //  [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
  //  NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
   //     [self showAlertWithResult:result];
    });
}

@end

@interface EsptouchPlugPlugin()<FlutterStreamHandler>

@property (strong,nonatomic)MySocketServer *socketserver;

// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;

@property (nonatomic, assign) BOOL _isConfirmState;

@property (nonatomic, strong) NSCondition *_condition;

@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;

@property (nonatomic, strong) FlutterEventSink eventSink;


@end
@implementation EsptouchPlugPlugin



+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  EsptouchPlugPlugin* instance = [[EsptouchPlugPlugin alloc] init];
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"esptouch_plug"
            binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
  FlutterEventChannel* streamChannel =
      [FlutterEventChannel eventChannelWithName:@"esptouch_plugin_event"
                                binaryMessenger:[registrar messenger]];
  [streamChannel setStreamHandler:instance];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

   if (self._esptouchDelegate == nil) {
         self._esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
         self._condition = [[NSCondition alloc]init];

     }
      if (_socketserver == nil) {
             _socketserver = [MySocketServer sharedServer];
                _socketserver.delegate = self;
         }
  if ([@"espTouchConfig" isEqualToString:call.method]) {
        NSString *ssid = call.arguments[@"ssid"];

         NSString *bssid = call.arguments[@"bssid"];

         NSString *password = call.arguments[@"password"];

    [self startConfigwithSsid:ssid andBssid:bssid andPassword:password];

    result([@"iOS " stringByAppendingString:ssid]);
  }
   if ([@"openLocalServer" isEqualToString:call.method]) {
     [_socketserver startServer:1024];
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
     if ([@"closeLocalServer" isEqualToString:call.method]) {
         [_socketserver stopServer];
          [self cancel];
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
      }
       if ([@"writeData" isEqualToString:call.method]) {
           NSString *data = call.arguments[@"data"];
           [_socketserver writeData:data];
          result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
        } else {
    result(FlutterMethodNotImplemented);
  }
}


- (void) startConfigwithSsid:(NSString *)ssid andBssid:(NSString *)bssid andPassword:(NSString *)password{
     dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                // execute the task
                NSArray *esptouchResultArray = [self executeForResultsWithSsid:ssid bssid:bssid password:password taskCount:1 broadcast:1];
                // show the result to the user in UI Main Thread
                dispatch_async(dispatch_get_main_queue(), ^{


                    ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                    // check whether the task is cancelled and no results received
                    if (!firstResult.isCancelled)
                    {
                        NSMutableString *mutableStr = [[NSMutableString alloc]init];
                        NSUInteger count = 0;
                        // max results to be displayed, if it is more than maxDisplayCount,
                        // just show the count of redundant ones
                        const int maxDisplayCount = 5;
                        if ([firstResult isSuc])
                        {

                            for (int i = 0; i < [esptouchResultArray count]; ++i)
                            {
                                ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                                [mutableStr appendString:[resultInArray description]];
                                [mutableStr appendString:@"\n"];
                                count++;
                                if (count >= maxDisplayCount)
                                {
                                    break;
                                }
                            }

                            if (count < [esptouchResultArray count])
                            {
                                [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                            }

    //                       [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:mutableStr delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
     //                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Execute Result" message:mutableStr preferredStyle:UIAlertControllerStyleAlert];
     //                       alert.accessibilityLabel = @"executeResult";

     //                       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"I know" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    //                        }];
    //                        [alert addAction:action1];
    //                        [self presentViewController:alert animated:YES completion:nil];
                        }

                        else
                        {
    //                        [[[UIAlertView alloc]initWithTitle:@"Execute Result" message:@"Esptouch did not find the device" delegate:nil cancelButtonTitle:@"I know" otherButtonTitles:nil]show];
    //                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Execute Result" message:@"Esptouch did not find the device" preferredStyle:UIAlertControllerStyleAlert];
    //                        alert.accessibilityLabel = @"executeResult";

    //                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"I know" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    //                        }];
     //                       [alert addAction:action1];
     //                       [self presentViewController:alert animated:YES completion:nil];
                        }
                    }

                });
            });
}

- (NSArray *) executeForResultsWithSsid:(NSString *)apSsid bssid:(NSString *)apBssid password:(NSString *)apPwd taskCount:(int)taskCount broadcast:(BOOL)broadcast
{
    [self._condition lock];
    self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd];
    // set delegate
    NSLog(@"xxxxxx: %@ %@ %@",apSsid,apBssid,apPwd);

    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self._esptouchTask setPackageBroadcast:broadcast];
    [self._condition unlock];
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}

- (void) cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
        self._esptouchTask = nil;
    }
    [self._condition unlock];
}


-(void)didReceiveData:(NSString *)str{
 _eventSink(str);

}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  return nil;
}
@end
