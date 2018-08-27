//
//  ViewController.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/23.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "ViewController.h"
#import "LTxMsgForSipprTypeTableViewController.h"
#import "LTxMsgForSipprPushTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (IBAction)showMsgCenter:(UIButton *)sender {
    LTxMsgForSipprTypeTableViewController* msgTypeVC = [[LTxMsgForSipprTypeTableViewController alloc] init];
    [self.navigationController pushViewController:msgTypeVC animated:true];
}

- (IBAction)showPushConfig:(UIButton *)sender {
    LTxMsgForSipprPushTableViewController* pushVC = [[LTxMsgForSipprPushTableViewController alloc] init];
    [self.navigationController pushViewController:pushVC animated:true];
}

@end
