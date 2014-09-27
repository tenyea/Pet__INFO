//
//  MyAskDetailTopCell.m
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskDetailTopCell.h"
#import "UIImageView+AFNetworking.h"
@implementation MyAskDetailTopCell

- (void)awakeFromNib
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(81, 0, 239, 15)];
    [self.contentView addSubview:_bottomView];

    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(81, 10, 184, 15)];
    _titleLabel.font = FONT(12);
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _petImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(81, 33, 184, 92)];
    [self.contentView addSubview:_petImageVIew];
    
//    填充底部视图
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 33, 14)];
    label.text = @"宠物:";
    label.textColor = [UIColor grayColor];
    label.font = FONT(12);
    [_bottomView addSubview:label];
    
    _petName = [[UILabel alloc]initWithFrame:CGRectMake(38, 0, 61, 14)];
    _petName.font = FONT(12);
    [_bottomView addSubview:_petName];
    
    _askTime = [[UILabel alloc]initWithFrame:CGRectMake(169, 3, 70, 10)];
    _askTime.font = FONT(12);
    [_bottomView addSubview:_askTime];
}

-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic ) {
        _dic = dic;
        [self setNeedsDisplay];

    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_dic) {
        return;
    }
    _authorLabel.text =  [_dic objectForKey:@"userName"];
    NSString *str ;
    _titleLabel.text = [_dic objectForKey:@"postText"];
    str = _titleLabel.text;
    
    CGSize size = [str  boundingRectWithSize:CGSizeMake(184, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
    _titleLabel.height = size.height + 5;
    _petName.text =  [_dic objectForKey:@"petName"];
    [_petName sizeToFit];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = [_dic objectForKey:@"postTime"] ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _askTime.text = [dateFormatter stringFromDate:date];
    
    if ([[_dic objectForKey:@"postImg"] isEqualToString:@""]) {
        _bottomView.top = _titleLabel.bottom + 2;
    }else{
        _petImageVIew.top = _titleLabel.bottom + 4;
        [_petImageVIew setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"postImg"] ]]  ;
        _bottomView.top = _petImageVIew.bottom + 2;
    }


}

+(float) getCellHeight : (NSDictionary *)dic{
    if (dic) {
        NSString *content = [dic objectForKey:@"postText"];
        CGSize size = [content  boundingRectWithSize:CGSizeMake(184, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
        
        float height = 10 + size.height + 5 ;
        height = height + 2 + 15 + 2;
        if ([[dic objectForKey:@"postImg"] isEqualToString:@""]) {
            return ceilf(height);
        }else{
            height += 96;
            return ceilf(height);
        }
    }else{
        return 0;
    }
    
}

@end
