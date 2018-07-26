//
//  LTxMsgForSipprModel.h
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 消息类别
 **/
@interface LTxMsgForSipprTypeModel : NSObject
/**
 * 消息类别编码
 **/
@property (nonatomic, strong) NSString* msgTypeId;

/**
 * 消息类别图标
 **/
@property (nonatomic, strong) NSString* msgImageName;
/**
 * 消息类别名称
 **/
@property (nonatomic, strong) NSString* msgTypeName;
/**
 * 该类别消息的未读数量
 **/
@property (nonatomic, assign) NSInteger msgCount;
/**
 * 预览内容
 **/
@property (nonatomic, strong) NSString* msgOverview;
/**
 * 时间
 **/
@property (nonatomic, strong) NSString* msgDate;



/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgTypeId:(NSString*)msgTypeId imageName:(NSString *)imageName typeName:(NSString*)typeName msgCount:(NSInteger)msgCount msgOverview:(NSString*)msgOverview msgDate:(NSString*)msgDate;

+(instancetype)instanceWithJSONString:(NSString*)jsonString;
+(instancetype)instanceWithDictionary:(NSDictionary*)dic;
@end


/**
 * 消息详情
 **/
@interface LTxMsgForSipprMsgModel : NSObject
/**
 * 消息编码
 **/
@property (nonatomic, strong) NSString* msgId;

/**
 * 消息的阅读状态
 **/
@property (nonatomic, assign) BOOL readState;

/**
 * 消息是否携带附件
 **/
@property (nonatomic, assign) BOOL hasAttachment;

/**
 * 消息名称
 **/
@property (nonatomic, strong) NSString* msgName;
/**
 * 消息内容
 **/
@property (nonatomic, strong) NSString* msgContent;
/**
 * 时间
 **/
@property (nonatomic, strong) NSString* msgDate;

/**
 * 链接URL
 **/
@property (nonatomic, strong) NSString* linkUrl;
/**
 * 携带参数
 **/
@property (nonatomic, strong) NSString* msgParams;
/**
 * 业务系统对应的GUID
 **/
@property (nonatomic, strong) NSString* rowGuid;

/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgId:(NSString *)msgId readState:(BOOL)readState hasAttachment:(BOOL)hasAttachment msgName:(NSString*)msgName msgContent:(NSString*)msgContent msgDate:(NSString*)msgDate linkUrl:(NSString*)linkUrl msgParams:(NSString*)msgParams rowGuid:(NSString*)rowGuid;

+(instancetype)instanceWithJSONString:(NSString*)jsonString;
+(instancetype)instanceWithDictionary:(NSDictionary*)dic;
@end
