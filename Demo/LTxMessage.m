//
//  LTxMessage.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMessage.h"
#import "JPUSHService.h"
#import "LTxMsgForSipprViewModel.h"
#import "LTxCorePopup.h"
#import "LTxMsgForSipprMsgTableViewController.h"//通知&公告&系统提醒
@implementation LTxMessage
/**
 * 单例模式
 **/
static LTxMessage *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceTokenLTxMessage;
    dispatch_once(&onceTokenLTxMessage, ^{
        _instance = [[LTxMessage alloc] init];
        [_instance addNotificationObserver];
    });
    
    return _instance;
}


/**
 * 程序启动
 **/
+(void)setupWithLaunchOptions:(NSDictionary *)launchOptions{
    NSString* pushId = [LTxCoreConfig sharedInstance].pushId;
    [JPUSHService setupWithOption:launchOptions appKey:pushId channel:@"Publish channel" apsForProduction:YES];
    
    //本地推送
    UILocalNotification * localNotify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotify){
        [LTxMessage handleLocalNotification:localNotify];
    }
    //通过点击通知栏信息启动时
    if(launchOptions != nil) {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo){
            [LTxMessage handleRemoteNotification:userInfo];
        }
    }
    
    
    
}

#pragma mark - Push

/**
 * 注册推送服务
 **/
+(void)registerPushService{
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:( UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
}

/**
 * 上报DeviceToken
 **/
+ (void)registerDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

/**
 *  设置别名
 */
+ (void)setAlias{
    NSString* userRowGuid = [NSUserDefaults lt_objectForKey:USERDEFAULT_USER_NUMBER];
    NSString* preAlias;
    if ([LTxCoreConfig sharedInstance].isDebug) {
        preAlias = [NSString stringWithFormat:@"%@%@",@"U",userRowGuid.lowercaseString];
    }else{
        preAlias = [NSString stringWithFormat:@"%@%@",@"R",userRowGuid.lowercaseString];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:preAlias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"设置别名：%@",iAlias);
        } seq:preAlias.hash];
    });
}

/**
 *  清除别名
 */
+ (void)eraseAlias{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {} seq:1];
}

/**
 *  处理收到的APNS消息
 */
+ (void)handleRemoteNotification:(NSDictionary *)userInfo{
    //上报消息
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (!userInfo) {
        return;
    }
    //解析消息，并根据对应的业务处理
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    NSString* msgID = [userInfo objectForKey:@"id"];
    NSString* userNumber = [userInfo objectForKey:@"userNumber"];
    
    [LTxMsgForSipprViewModel msgDetailWithMsgId:msgID userNumber:userNumber complete:^(NSString *errorTips, NSDictionary *msgDic) {
        if (errorTips){
            NSLog(@"消息获取失败：%@",errorTips);
            return ;
        }
        [LTxMessage handlePushMsgWithApplicationState:state msgId:msgID msgItem:msgDic];
    }];
}

/**
 *  处理收到的本地消息
 */
+ (void)handleLocalNotification:(UILocalNotification *)notification{
    NSDictionary* userInfo = notification.userInfo;
    if (userInfo) {
        [LTxMessage coreMessageHandleWithItem:userInfo];
    }
}
/**
 * 消息推送处理
 **/
+(void)handlePushMsgWithApplicationState:(UIApplicationState)state msgId:(NSString*)msgID msgItem:(NSDictionary*)msgItem{
    NSLog(@"收到的推送数据内容是：%@",msgItem);
    NSString* msgTitle = [msgItem objectForKey:@"title"];
    NSString* msgContent = [msgItem objectForKey:@"noticeContent"];
    
    //如果程序处于前台，则弹出提示框；如果后台，则说明是用户手动点击消息进入的，直接打开消息即可
    if (state == UIApplicationStateActive) {
        UIAlertAction* openAction = [UIAlertAction actionWithTitle:@"立即查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [LTxMessage handleCommonPushMessageWithMsgId:msgID msgItem:msgItem];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:LTxLocalizedString(@"text_cmn_get_it") style:UIAlertActionStyleCancel handler:nil];
        
        UIViewController* sourceController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIView* sourceView = sourceController.view;
        CGPoint center = sourceView.center;
        
        CGRect frame = CGRectMake(center.x - 50, center.y - 50, 100, 100);
        
        [LTxCorePopup showAlertOnViewController:sourceController sourceView:sourceView sourceRect:frame style:UIAlertControllerStyleAlert title:msgTitle message:msgContent actions:openAction,cancelAction,nil];
    }else{
        [LTxMessage handleCommonPushMessageWithMsgId:msgID msgItem:msgItem];
    }
}
/**
 * 消息推送处理
 **/
+(void)handleCommonPushMessageWithMsgId:(NSString*)msgId msgItem:(NSDictionary*)msgItem{
    if (msgId) {//消息置为已读
        [LTxMsgForSipprViewModel updateMsgReadStateWithMsgId:msgId complete:nil];
    }
    
    [LTxMessage coreMessageHandleWithItem:msgItem];
    
}

#pragma mark - Msg
/**
 * 核心消息处理模块，处理特定类型的消息
 *
 ***/
+(void)coreMessageHandleWithItem:(NSDictionary*)msgItem{
    
    NSDictionary* messageType = [msgItem objectForKey:@"msgType"];
    NSString* moduleType = [messageType objectForKey:@"msgTypeCode"];
    
    if ([moduleType isEqualToString:@"systemNotification"]//系统提醒
        ||[moduleType isEqualToString:@"announcement"]//公告
        ||[moduleType isEqualToString:@"notification"]//通知
        ) {//进入系统消息区
        LTxMsgForSipprMsgTableViewController *detailVC = [[LTxMsgForSipprMsgTableViewController alloc] init];
        detailVC.msgTypeCode = moduleType;
        if([moduleType isEqualToString:@"systemNotification"]){
            detailVC.title = @"系统提醒";
        }else if([moduleType isEqualToString:@"announcement"]){
            detailVC.title = @"公告";
        }else if([moduleType isEqualToString:@"notification"]){
            detailVC.title = @"通知";
        }
        
        UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabarController = (UITabBarController*)rootVC;
            UINavigationController* navi = tabarController.selectedViewController;
            detailVC.hidesBottomBarWhenPushed = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [navi pushViewController:detailVC animated:true];
            });
        }else{//2s 之后重试一次，防止因程序未完全启动导致的错误
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                if ([rootVC isKindOfClass:[UITabBarController class]]) {
                    UITabBarController* tabarController = (UITabBarController*)rootVC;
                    UINavigationController* navi = tabarController.selectedViewController;
                    detailVC.hidesBottomBarWhenPushed = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [navi pushViewController:detailVC animated:true];
                    });
                }
            });
        }
    }else{//根据不同的类型，获取消息内容，然后调用核心消息处理模块
        if ([LTxMessage sharedInstance].msgHandlerCallback) {
            [LTxMessage sharedInstance].msgHandlerCallback(msgItem);
        }
    }
}

#pragma mark - Observer

-(void)addNotificationObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveLocalNotification:) name:LTX_NOTIFICATION_MSG_DID_SELECT_KEY object:nil];//消息被点击时发送的通知
}

-(void)recieveLocalNotification:(NSNotification*)notification{
    NSString* notificationKeyName = [notification name];
    if ([notificationKeyName isEqualToString:LTX_NOTIFICATION_MSG_DID_SELECT_KEY]) {//消息被点击时发送的通知
        NSDictionary* item = notification.object;
        [LTxMessage coreMessageHandleWithItem:item];
    }
}

@end
