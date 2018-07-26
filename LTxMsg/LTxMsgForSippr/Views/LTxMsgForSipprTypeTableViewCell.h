//
//  LTxMsgForSipprTypeTableViewCell.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <LTxCore/LTxCore.h>
#import "LTxMsgForSipprModel.h"

/**
 * 消息类别预览
 * 展示消息类别，未读数量，预览消息等
 **/
@interface LTxMsgForSipprTypeTableViewCell : LTxCoreBaseTableViewCell
@property (nonatomic, strong) LTxMsgForSipprTypeModel* model;
@end
