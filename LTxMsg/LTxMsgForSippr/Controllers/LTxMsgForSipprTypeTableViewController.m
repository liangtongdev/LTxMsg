//
//  LTxMsgForSipprTypeTableViewController.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprTypeTableViewController.h"
#import "LTxMsgForSipprTypeTableViewCell.h"
#import "LTxMsgForSipprViewModel.h"
#import "LTxMsgForSipprMsgTableViewController.h"
@interface LTxMsgForSipprTypeTableViewController ()
@property (nonatomic, strong) NSMutableArray* dataSource;
@end

static NSString* LTxSipprMsgTypeTableViewCellIdentifier = @"LTxSipprMsgTypeTableViewCellIdentifier";
@implementation LTxMsgForSipprTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LTxLocalizedString(@"text_message_mine");
    
    [self setupDefaultConfig];
    
    [self showAnimatingActivityView];
    [self msgTypeListFetch];
}

-(void)setupDefaultConfig{
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"LTxMsgForSipprTypeTableViewCell" bundle:SelfBundle] forCellReuseIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf msgTypeListFetch];
    }];
}

-(void)msgTypeListFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxMsgForSipprViewModel msgTypeOverviewListFetchComplete:^(NSString *errorTips, NSArray *msgTypeList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [msgTypeList mutableCopy];
        strongSelf.errorTips = errorTips;
        [strongSelf finishSipprRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTxMsgForSipprTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[LTxMsgForSipprTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprMsgTypeTableViewCellIdentifier];
    }
    NSDictionary* msgTypeDic = [self.dataSource objectAtIndex:indexPath.row];
    cell.model = [LTxMsgForSipprTypeModel instanceWithDictionary:msgTypeDic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LTxMsgForSipprTypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LTxMsgForSipprTypeModel* model = cell.model;
    
    if (model.msgCount > 0) {//刷新本页数据
        NSMutableDictionary* msgTypeDic = [[self.dataSource objectAtIndex:indexPath.row] mutableCopy];
        [msgTypeDic setObject:@0 forKey:@"unHandledCount"];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:msgTypeDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }
    
    //跳转页面
    LTxMsgForSipprMsgTableViewController* msgListVC = [[LTxMsgForSipprMsgTableViewController alloc] init];
    msgListVC.title = model.msgTypeName;
    msgListVC.msgTypeCode = model.msgTypeId;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:msgListVC animated:true];
    });
}
@end
