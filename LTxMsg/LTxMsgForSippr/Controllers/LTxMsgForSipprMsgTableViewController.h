//
//  LTxMsgForSipprMsgTableViewController.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

/**
 * 消息列表预览
 **/
#import <LTxCore/LTxCore.h>


/**
 * 消息被点击时发送的通知
 **/
extern  NSString* const LTX_NOTIFICATION_MSG_DID_SELECT_KEY;

@interface LTxMsgForSipprMsgTableViewController : LTxCoreBaseTableViewController
//消息类别编码
@property (nonatomic, strong) NSString* msgTypeCode;
@end
