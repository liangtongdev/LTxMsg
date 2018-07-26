//
//  LTxMsgForSipprMsgAttachmentListPopup.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LTxCore/LTxCore.h>

/**
 * 消息附件列表弹出框
 **/
@interface LTxMsgForSipprMsgAttachmentListPopup : UIView
@property (nonatomic, copy) LTxCallbackBlock closeAction;
@property (nonatomic, copy) LTxDictionaryCallbackBlock filePreviewBlock;
-(void)setupWithFileList:(NSArray*)fileList;
@end
