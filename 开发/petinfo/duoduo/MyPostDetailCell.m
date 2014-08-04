//
//  MyPostDetailCell.m
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostDetailCell.h"

@implementation MyPostDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        _contentLabel = [[UILabel alloc]initWithFrame: CGRectMake(15, 10,  ScreenWidth - 15 * 2 , 0)];
        _contentLabel.textColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_contentLabel];
        
        _userNameLabel = [[UILabel alloc]initWithFrame: CGRectMake(15, 0,  195 , 15)];
        _userNameLabel.textColor = [UIColor colorWithRed:0.38 green:0.61 blue:0.37 alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_userNameLabel];
        _timeLabel = [[UILabel alloc]initWithFrame: CGRectMake(ScreenWidth - 90, 0,  80 , 15)];
        _timeLabel.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic {
    if (_dic != dic) {
        _dic = dic;
        [self setNeedsDisplay];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_dic) {
        return;
    }
    _userNameLabel.text = [_dic objectForKey:@"petPhotoDisUserName"];
    
    
    //转换时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = [_dic objectForKey:@"petPhotoDisTime"] ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];
    
    
    NSString *str = [_dic objectForKey:@"petPhotoDisText"];
    _contentLabel.text =str;
    
    CGSize size = [str  boundingRectWithSize:CGSizeMake(ScreenWidth - 15 *2 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    _contentLabel.height = size.height;
//调整位置
    _userNameLabel.top = _contentLabel.bottom + 5;
    _timeLabel.top = _userNameLabel.top;
}
+(float) getCellHeight : (NSDictionary *)dic{
    
    if (dic) {
        NSString *content = [dic objectForKey:@"petPhotoDisText"];
        CGSize size = [content  boundingRectWithSize:CGSizeMake(ScreenWidth - 15 *2 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
        
        float height = size.height + 15 + 5 + 15 +5 ;//回复高度 + 上高 + 下高 + 用户名高度 + 用户名下高
        return height;
    }else{
        return 0;
    }
}
@end
