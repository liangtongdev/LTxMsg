//
//  LTxMessage.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LTxCore/LTxCore.h>

/**
 * 消息被点击时发送的通知
 **/
extern NSString* const LTX_NOTIFICATION_MSG_DID_SELECT_KEY;


/**
 * APNs消息处理
 **/
@interface LTxMessage : NSObject

/**
 * 消息处理核心
 **/
@property (nonatomic, copy) LTxDictionaryCallbackBlock msgHandlerCallback;

//单例
+ (instancetype)sharedInstance;
/**
 * 程序启动
 * 设置推送服务
 * 处理程序启动时携带的信息
 *
 **/
+(void)setupWithLaunchOptions:(NSDictionary *)launchOptions;

#pragma mark - Push

/**
 * 注册推送服务
 **/
+(void)registerPushService;

/**
 * 上报DeviceToken
 **/
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 *  设置别名
 */
+ (void)setAlias;

/**
 *  清除别名
 */
+ (void)eraseAlias;

/**
 *  处理收到的APNS消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)userInfo;
/**
 *  处理收到的本地消息
 */
+ (void)handleLocalNotification:(UILocalNotification *)notification;

@end
