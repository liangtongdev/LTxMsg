//
//  LTxMsgForSipprMsgAttachmentListPopup.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprMsgAttachmentListPopup.h"
@interface LTxMsgForSipprMsgAttachmentListPopup()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray* fileList;

@end
@implementation LTxMsgForSipprMsgAttachmentListPopup

-(void)setupWithFileList:(NSArray*)fileList{
    [self setup];
    _fileList = fileList;
}

-(void)setup{
    self.layer.cornerRadius = 8.f;
    self.clipsToBounds = YES;
    
    
    [self.closeBtn setImage:LTxImageWithName(@"ic_msg_extra_attachment_close") forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)closeBtnPressed:(UIButton*)btn{
    if (_closeAction) {
        _closeAction();
    }
}

#pragma mark -- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_filePreviewBlock) {
        NSDictionary* fillItem = [_fileList objectAtIndex:indexPath.row];
        _filePreviewBlock(fillItem);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"LTxMsgForSipprMsgAttachmentListPopupCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* cellItem =  [_fileList objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellItem objectForKey:@"title"];
    return cell;
}

@end
