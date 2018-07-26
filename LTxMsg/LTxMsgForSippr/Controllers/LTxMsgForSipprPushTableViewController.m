//
//  LTxMsgForSipprPushTableViewController.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprPushTableViewController.h"
#import "LTxMsgForSipprViewModel.h"
@interface LTxMsgForSipprPushTableViewController ()
@property(nonatomic,strong)NSArray* dataSource;
@property(nonatomic,strong)NSMutableSet* selectedConfigSet;
@end
static NSString* LTxSipprMsgPushDiyTableViewCellIdentifier = @"LTxSipprMsgPushDiyTableViewCellIdentifier";
@implementation LTxMsgForSipprPushTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LTxLocalizedString(@"text_message_push_diy");
    
    [self setupDefaultConfig];
    [self showAnimatingActivityView];
    [self pushTypePushListFetch];
}
/*修改TableView的样式*/
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(void)setupDefaultConfig{
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGFLOAT_MIN)];
    
    __weak __typeof(self) weakSelf = self;
    [self addPullDownRefresh:^{
        [weakSelf pushTypePushListFetch];
    }];
}

-(void)pushTypePushListFetch{
    __weak __typeof(self) weakSelf = self;
    [LTxMsgForSipprViewModel pushTypeListFetchComplete:^(NSString *errorTips, NSArray *pushTypeList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataSource = [pushTypeList mutableCopy];
        if (!errorTips && [pushTypeList count] == 0) {
            strongSelf.errorTips = LTxLocalizedString(@"text_message_push_no_item");
        }else{
            strongSelf.errorTips = errorTips;
        }
        [strongSelf finishSipprRefreshing];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_selectedConfigSet) {
        [LTxMsgForSipprViewModel diyPushTypeList:_selectedConfigSet complete:nil];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LTxSipprMsgPushDiyTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LTxSipprMsgPushDiyTableViewCellIdentifier];
    }
    NSDictionary* cellItem = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellItem objectForKey:@"msgTypeName"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    BOOL enable = [[cellItem objectForKey:@"enable"] boolValue];
    if (enable) {
        [self.selectedConfigSet addObject:[cellItem objectForKey:@"msgTypeCode"]];
    }
    cell.accessoryView = [self switchWithStatus:enable tag:indexPath.row];
    return cell;
}

-(UISwitch *)switchWithStatus:(BOOL)status tag:(NSInteger)tag{
    UISwitch * retSwitch = [[UISwitch alloc] init];
    retSwitch.onTintColor = [LTxCoreConfig sharedInstance].skinColor;
    [retSwitch setOn:status];
    retSwitch.tag = tag;
    [retSwitch addTarget:self action:@selector(switchStatusChanged:) forControlEvents:UIControlEventValueChanged];
    return  retSwitch;
}

-(void)switchStatusChanged:(UISwitch *)changedSwitch{
    NSString* selectedTypeCode = [[_dataSource objectAtIndex:changedSwitch.tag] objectForKey:@"msgTypeCode"];
    if (changedSwitch.on) {
        [self.selectedConfigSet addObject:selectedTypeCode];
    }else{
        [self.selectedConfigSet removeObject:selectedTypeCode];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


-(NSMutableSet*)selectedConfigSet{
    if (!_selectedConfigSet) {
        _selectedConfigSet = [[NSMutableSet alloc] init];
    }
    return _selectedConfigSet;
}
@end
