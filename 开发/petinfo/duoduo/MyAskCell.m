//
//  MyAskCell.m
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskCell.h"
#import "InquiryModel.h"
@implementation MyAskCell

- (void)awakeFromNib
{
    
}

-(void)setModel:(InquiryModel *)model{
    if (_model != model) {
        _model = model;
        
        self.userNameLabel.text = _model.userName;
        self.petNameLabel.text = _model.petName ;
        self.timeLabel.text = _model.postTime;
        self.countLabel.text = [NSString stringWithFormat:@"%@",_model.replyCount];
        self.titleLabel.text = _model.postTitle;

    }
   }

@end
