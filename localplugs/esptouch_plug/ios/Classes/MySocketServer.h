//
//  MySocketServer.h
//  EspTouchDemo
//
//  Created by 洪翔 on 2019/11/20.
//  Copyright © 2019 Espressif. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MySocketServerDelegate

-(void)didReceiveData:(NSString *)data;

@end
@interface MySocketServer : NSObject
+ (instancetype)sharedServer;
- (void)startServer:(int)port;
- (void)stopServer;
- (void)writeData:(NSDictionary *)data;
@property (nonatomic, weak) id<MySocketServerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
