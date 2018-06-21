//
//  NetWorkHelper.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "NetWorkHelper.h"


#define NOTIFICATION_NONETWORK @"NOTIFICATION_NONETWORK"                        //有网络到无网络的通知
#define NOTIFICATION_HAVENETWORK @"NOTIFICATION_HAVENETWORK"                    //无网络到有网络的通知

@interface NetWorkHelper()

@property(nonatomic,assign) NSInteger previousStatus;

@end


@implementation NetWorkHelper

+ (instancetype)shareInstance
{
    static NetWorkHelper *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NetWorkHelper alloc] init];
        [shareInstance startNotification];
        
    });
    return shareInstance;
}




- (void)startNotification{

    self.previousStatus = -1; //没有状态
    
    self.reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [_reachability startNotifier];


}

- (NetworkStatus)currentNetworkStatus{
    return [self.reachability currentReachabilityStatus];
    
}


#pragma mark - 网络改变监听

- (void)networkChanged:(NSNotification *)notification
{
    
    Reachability *reachability = (Reachability *)notification.object;
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (_previousStatus == -1) {
        _previousStatus = status;
    }else{
        if (status == _previousStatus) {
            return;
        }
    }
    
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(_previousStatus));
    
    if (status == NotReachable){
        
        if (self.networkUnconnectionBlock) {
            self.networkUnconnectionBlock();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NONETWORK object:nil];
    
    }else{
        
        if (_previousStatus == NotReachable ) {
            
            if (self.networkReconnectionBlock) {
                self.networkReconnectionBlock();
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HAVENETWORK object:nil];
            
        }
    }
    
    _previousStatus = status;
    
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"NetWorkHelper dealloc");

}

@end
