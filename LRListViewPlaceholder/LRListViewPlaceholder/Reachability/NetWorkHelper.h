//
//  NetWorkHelper.h
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

typedef void(^NetworkReconnectionBlock)(void);
typedef void(^NetworkUnconnectionBlock)(void);

@interface NetWorkHelper : NSObject

+ (instancetype)shareInstance;

/**
 *  reachability类, 用于处理网络变化以及获取网络状态
 */
@property(nonatomic,strong) Reachability* reachability;

/**
 *  当前网络状态
 */
@property(nonatomic,assign) NetworkStatus currentNetworkStatus;

/**
 *  用于网络从无网络到有网络的重连操作
 */
@property(nonatomic,copy) NetworkReconnectionBlock networkReconnectionBlock;

/**
 *  用于网络从有网络到无网络所做的操作
 */
@property(nonatomic,copy) NetworkUnconnectionBlock networkUnconnectionBlock;


/**
 *  @note 用于开始监听网络变化
 */
- (void)startNotification;


@end
