//
//  LTxMsgForSipprModel.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprModel.h"

/**
 * 消息类别
 **/
@implementation LTxMsgForSipprTypeModel

/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgTypeId:(NSString*)msgTypeId imageName:(NSString *)imageName typeName:(NSString*)typeName msgCount:(NSInteger)msgCount msgOverview:(NSString*)msgOverview msgDate:(NSString*)msgDate{
    
    LTxMsgForSipprTypeModel* _instance = [[LTxMsgForSipprTypeModel alloc] init];
    
    _instance.msgTypeId = msgTypeId;
    _instance.msgImageName = imageName;
    _instance.msgTypeName = typeName;
    _instance.msgCount = msgCount;
    _instance.msgOverview = msgOverview;
    _instance.msgDate = msgDate;
    return _instance;
}

+(instancetype)instanceWithJSONString:(NSString*)jsonString{
    LTxMsgForSipprTypeModel* _instance = [[LTxMsgForSipprTypeModel alloc] init];
    
    //Convert String to Dictionary
    NSError* jsonError;
    NSDictionary *jsonDic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if(!jsonError){
        [_instance setValuesForKeysWithDictionary:jsonDic];
    }
    
    return _instance;
}
+(instancetype)instanceWithDictionary:(NSDictionary*)dic{
    LTxMsgForSipprTypeModel* _instance = [[LTxMsgForSipprTypeModel alloc] init];
    if (dic) {
        [_instance setValuesForKeysWithDictionary:dic];
    }
    return _instance;
}

//映射用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"msgTypeCode"]) {
        self.msgTypeId = value;
        self.msgImageName = [NSString stringWithFormat:@"ic_msg_type_%@",value];
    }else if ([key isEqualToString:@"unHandledCount"]) {
        self.msgCount = [value integerValue];
    }else if ([key isEqualToString:@"lastMsg"]) {
        self.msgOverview = [value objectForKey:@"lastContent"];
        self.msgDate = [value objectForKey:@"lastTime"];
    }
}
@end

/**
 * 消息详情
 **/
@implementation LTxMsgForSipprMsgModel

/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgId:(NSString *)msgId readState:(BOOL)readState hasAttachment:(BOOL)hasAttachment msgName:(NSString*)msgName msgContent:(NSString*)msgContent msgDate:(NSString*)msgDate linkUrl:(NSString*)linkUrl msgParams:(NSString*)msgParams rowGuid:(NSString*)rowGuid{
    
    LTxMsgForSipprMsgModel* _instance = [[LTxMsgForSipprMsgModel alloc] init];
    _instance.msgId = msgId;
    _instance.readState = readState;
    _instance.hasAttachment = hasAttachment;
    _instance.msgName = msgName;
    _instance.msgContent = msgContent;
    _instance.msgDate = msgDate;
    _instance.linkUrl = linkUrl;
    _instance.msgParams = msgParams;
    _instance.rowGuid = rowGuid;
    
    return _instance;
}

+(instancetype)instanceWithJSONString:(NSString*)jsonString{
    LTxMsgForSipprMsgModel* _instance = [[LTxMsgForSipprMsgModel alloc] init];
    
    //Convert String to Dictionary
    NSError* jsonError;
    NSDictionary *jsonDic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if(!jsonError){
        [_instance setValuesForKeysWithDictionary:jsonDic];
    }
    
    return _instance;
}

+(instancetype)instanceWithDictionary:(NSDictionary*)dic{
    LTxMsgForSipprMsgModel* _instance = [[LTxMsgForSipprMsgModel alloc] init];
    if (dic) {
        [_instance setValuesForKeysWithDictionary:dic];
    }
    return _instance;
}

//映射用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.msgId = value;
    }else if ([key isEqualToString:@"status"]) {
        NSInteger status = [value integerValue];
        if (status != 0) {//已读
            self.readState = YES;
        }else{//未读
            self.readState = NO;
        }
    }else if ([key isEqualToString:@"extraFileCount"]) {//携带附件数量
        NSInteger extraFileCount = [value integerValue];
        if (extraFileCount > 0) {
            self.hasAttachment = YES;
        }else{
            self.hasAttachment = NO;
        }
    }else if ([key isEqualToString:@"title"]){
        self.msgName = value;
    }else if ([key isEqualToString:@"content"]){
        self.msgContent = value;
    }else if ([key isEqualToString:@"date"]){
        self.msgDate = value;
    }
}
@end
