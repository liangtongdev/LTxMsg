//
//  LTxMsgForSipprTypeTableViewCell.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/24.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "LTxMsgForSipprTypeTableViewCell.h"

@interface LTxMsgForSipprTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@end

@implementation LTxMsgForSipprTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupConfig];
}

-(void)setupConfig{
    self.countL.layer.cornerRadius = self.countL.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LTxMsgForSipprTypeModel *)model{
    _model = model;
    if (model) {
        self.iconView.image = [UIImage imageNamed:model.msgImageName];
        self.typeNameL.text = model.msgTypeName;
        if (model.msgCount > 0) {
            self.countL.clipsToBounds = YES;
            self.countL.backgroundColor = [UIColor redColor];
            if (model.msgCount > 99) {
                self.countL.font = [UIFont systemFontOfSize:9];
                self.countL.text = @"99+";
            }else{
                self.countL.text = [NSString stringWithFormat:@"%td",model.msgCount];
            }
        }else{
            self.countL.backgroundColor = [UIColor clearColor];
            self.countL.text = nil;
        }
        self.dateL.text = [NSDate lt_timeDescriptionWithDateString:model.msgDate];;
        self.contentL.text = model.msgOverview;
    }
}

@end
