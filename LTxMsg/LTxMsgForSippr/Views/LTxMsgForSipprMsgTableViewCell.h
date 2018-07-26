//
//  LTxMsgForSipprMsgTableViewCell.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <LTxCore/LTxCore.h>
#import "LTxMsgForSipprModel.h"

/**
 * 消息类别详情
 * 展示消息阅读状态，标题，预览消息等
 **/
@interface LTxMsgForSipprMsgTableViewCell : LTxCoreBaseTableViewCell
@property (nonatomic, strong) LTxMsgForSipprMsgModel* model;
@end
