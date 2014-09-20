//
//  MyPostCell.m
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostCell.h"
#import "PostModel.h"
#import "UIImageView+AFNetworking.h"
@implementation MyPostCell

- (void)awakeFromNib
{
    _askCount = [[UIImageView alloc]initWithFrame:CGRectMake(244, 53 , 15 , 15)];
    [_askCount setImage:[UIImage imageNamed:@"my_askcount.png"]];
    [self.contentView addSubview:_askCount];
    _goodCount = [[UIImageView alloc]initWithFrame:CGRectMake(276, 53, 15 , 15)];
    [_goodCount setImage:[UIImage imageNamed:@"my_goodcount.png"]];
    [self.contentView addSubview:_goodCount];
    
    _askCountLabel = [[UILabel alloc]initWithFrame: CGRectMake(261, 53, 60, 15)];
    _askCountLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    _askCountLabel.font = FONT(12);
    [self.contentView addSubview:_askCountLabel];
    _goodCountLabel = [[UILabel alloc]initWithFrame: CGRectMake(293, 53, 60, 15)];
    _goodCountLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    _goodCountLabel.font = FONT(12);
    [self.contentView addSubview:_goodCountLabel];
}

-(void)setModel:(PostModel *)model{
    if (_model != model) {
        _model = model;
        [self setNeedsDisplay];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLable.text = _model.petPhotoTitle;
//    从宠物名和头像  修改为 用户的
    [_petImageView setImageWithURL: [NSURL URLWithString:_model.userHead]];
    [_petName setText:_model.userName];
    
//转换时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = _model.petPhotoTime ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _postTime.text = [dateFormatter stringFromDate:date];

    NSString *str = [NSString stringWithFormat:@"%@",_model.petPhotoDis];
    [_askCountLabel setText:str];
    NSString *str1 = [NSString stringWithFormat:@"%@",_model.petPhotoGood];
    [_goodCountLabel setText:str1];
    
    //    调整左下角位置
    [_goodCountLabel sizeToFit];
    [_askCountLabel sizeToFit];
    _goodCountLabel.right = 320 - 15;
    _goodCount.right = _goodCountLabel.left - 5;
    _askCountLabel.right = _goodCount.left - 5;
    _askCount.right = _askCountLabel.left - 5;

}

@end
