//
//  LTxMsgForSipprMsgTableViewController.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprMsgTableViewController.h"
#import <LTxEepMSippr/LTxEepMSippr.h>
#import "LTxMsgForSipprMsgTableViewCell.h"
#import "LTxMsgForSipprMsgAttachmentListPopup.h"
#import "LTxCoreFilePreviewViewController.h"

/**
 * 消息被点击时发送的通知
 **/
NSString * const LTX_NOTIFICATION_MSG_DID_SELECT_KEY = @"LTX_NOTIFICATION_MSG_DID_SELECT_KEY";

@interface LTxMsgForSipprMsgTableViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) UIVisualEffectView * effectView;//附件展示时的毛玻璃特效
@property (nonatomic, strong) LTxMsgForSipprMsgAttachmentListPopup* popView;//附件列表弹出框
@end
static NSString* LTxSipprMsgTypeDetailTableViewCellIdentifier = @"LTxSipprMsgTypeDetailTableViewCellIdentifier";
@implementation LTxMsgForSipprMsgTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultConfig];
    
    [self showAnimatingActivityView];
    [self msgListFetch];
}

-(void)setupDefaultConfig{
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxMsgForSipprMsgTableViewCell" bundle:SelfBundle] forCellReuseIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf msgListFetch];
    } andPullUpRefresh:^{
        [weakSelf msgListPullup];
    }];
}

-(void)msgListFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxEepMUppViewModel msgListFetchWithMsgType:_msgTypeCode currentPage:1 maxResult:[LTxCoreConfig sharedInstance].pageSize complete:^(NSString *errorTips, NSArray *msgList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [msgList mutableCopy];
        strongSelf.errorTips = errorTips;
        [strongSelf finishSipprRefreshing];
        if ([msgList count] == [LTxCoreConfig sharedInstance].pageSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer resetNoMoreData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            });
        }
    }];
}

-(void)msgListPullup{
    __weak __typeof(self) weakSelf = self;
    NSInteger currentPage = self.dataSource.count / [LTxCoreConfig sharedInstance].pageSize + 1;
    [LTxEepMUppViewModel msgListFetchWithMsgType:_msgTypeCode currentPage:currentPage maxResult:[LTxCoreConfig sharedInstance].pageSize complete:^(NSString *errorTips, NSArray *msgList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.errorTips = errorTips;
        if ([msgList count] > 0) {
            [strongSelf.dataSource addObjectsFromArray:msgList];
        }
        [strongSelf finishSipprRefreshing];
        if (msgList.count < [LTxCoreConfig sharedInstance].pageSize) {//禁用加载更多
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxMsgForSipprMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxMsgForSipprMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprMsgTypeDetailTableViewCellIdentifier];
    }
    NSDictionary* msgDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxMsgForSipprMsgModel instanceWithDictionary:msgDic];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    //    NSLog(@"%td行，%td列 , 总行：%td",indexPath.section,indexPath.row,self.dataSource.count);
    if (indexPath.row >= (self.dataSource.count - 10)) {
        if ((self.dataSource.count < [LTxCoreConfig sharedInstance].pageSize || self.dataSource.count % [LTxCoreConfig sharedInstance].pageSize != 0 )) {
            return ;
        }else{
            if (!self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer beginRefreshing];
            }
        }
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary* msgDic = [self.dataSource objectAtIndex:indexPath.row];
    [self ltxHandleMessage:msgDic];
}

-(void)ltxHandleMessage:(NSDictionary*)msgDic{
    
    //先判断消息是否是通用消息，如果是通用类型，则直接处理，否则发送全局通知供其他处理
    
    NSString* msgTypeCode = [msgDic objectForKey:@"msgTypeCode"];
    if ([msgTypeCode isEqualToString:@"systemNotification"]) {//公告、通知、系统提醒
        int extraFileCount = [[msgDic objectForKey:@"extraFileCount"] intValue];//附件数量
        if (extraFileCount == 0) {//没有附件
            return;
        }
        if ([msgTypeCode isEqualToString:@"systemNotification"]) {//系统提醒，打开网页
            NSString* urlString = [msgDic objectForKey:@"linkUrl"];
            //预览网页
            LTxCoreFilePreviewViewController* filePreview = [[LTxCoreFilePreviewViewController alloc] init];
            filePreview.fileURL = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:filePreview animated:true];
            });
        }else{//公告、通知，打开附件列表
            NSString* rowGuid = [msgDic objectForKey:@"rowGuid"];
            //根据业务编码，获取消息详情（附件列表）,弹框展示列表，供用户选择查看
            /*父级节目使用 UIBlurEffect 毛玻璃特效类型
             *  UIBlurEffectStyleExtraLight,
             *  UIBlurEffectStyleLight,
             *  UIBlurEffectStyleDark
             */
            __weak __typeof(self) weakSelf = self;
            [self showAnimatingActivityView];
            [LTxEepMUppViewModel msgDetailWithMsgRowGuid:rowGuid complete:^(NSString *errorTips, NSDictionary *msgDic) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf hideAnimatingActivityView];
                strongSelf.errorTips = errorTips;
                if (!errorTips) {
                    NSArray* fileList = [msgDic objectForKey:@"files"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf showMsgAttachmentList:fileList];
                    });
                }
            }];
        }
    }else{
        NSNotification *notification = [NSNotification notificationWithName:LTX_NOTIFICATION_MSG_DID_SELECT_KEY object:msgDic];
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
    }
}

#pragma mark - 附件列表

-(void)showMsgAttachmentList:(NSArray*)attachmentList{
    if ([attachmentList count] == 0) {//无附件时，不展示弹出框
        return;
    }
    if (_effectView) {
        [_effectView removeFromSuperview];
    }
    if (_popView) {
        [_popView removeFromSuperview];
    }
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.alpha = 0.5;
    _effectView.frame =self.navigationController.view.bounds;
    [_effectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMsgAttachmentListView)]];
    [self.view addSubview:_effectView];
    
    //此处将附件框添加到view中
    NSArray *nibContents = [[NSBundle bundleForClass:self.class] loadNibNamed:@"LTxMsgForSipprMsgAttachmentListPopup" owner:nil options:nil];
    _popView = [nibContents lastObject];
    
    [_popView setupWithFileList:attachmentList];
    __weak __typeof(self) weakSelf = self;
    _popView.closeAction = ^{
        [weakSelf hideMsgAttachmentListView];
    };
    _popView.filePreviewBlock = ^(NSDictionary * fileItem) {
        //跳转页面，预览附件即可
        NSString* fileUrl = [fileItem objectForKey:@"fileUrl"];
        LTxCoreFilePreviewViewController* filePreview = [[LTxCoreFilePreviewViewController alloc] init];
        filePreview.fileURL = [NSURL URLWithString:[fileUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:filePreview animated:true];
        });
    };
    
    [self.view addSubview:_popView];
    CGPoint center = self.navigationController.view.center;
    _popView.frame = CGRectMake(center.x - 140, center.y - 200, 280, 320);
    _popView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.popView.alpha = 1;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];
}


- (void)hideMsgAttachmentListView{
    [UIView animateWithDuration:0.4 animations:^{
        self.popView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        [self.effectView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }];
    
}

@end
