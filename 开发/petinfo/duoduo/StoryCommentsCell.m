//
//  StoryCommentsCell.m
//  宠信
//
//  Created by tenyea on 14-8-13.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryCommentsCell.h"

@implementation StoryCommentsCell
@synthesize dic;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    return self;
}

-(void)_init{
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 15)];
    _userNameLabel.font = [UIFont systemFontOfSize:13];
    _userNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_userNameLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 100, 15)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, ScreenWidth - 40 , 0 )];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 0 ;
    _contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_contentLabel];
    
    _view = [[UIView alloc ]initWithFrame:CGRectMake(20,  0 ,ScreenWidth - 40 , 1)];
    _view.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_view];
}

-(void)layoutSubviews{
    [super layoutSubviews];
 
    _userNameLabel.text = [dic objectForKey:@"petPhotoDisUserName"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = [dic objectForKey:@"petPhotoDisTime"]  ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];
    [_timeLabel sizeToFit];
    
    NSString *str = [dic objectForKey:@"petPhotoDisText"];
    CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - 40, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    _contentLabel.height = size.height;
    _contentLabel.text = str;

    _view.top = self.height - 1;
}

+(float)getCommentHeight:(NSString *)str {
    
    float height =  5 + 15;
    //                计算高度
    CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - 40, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    height += size.height;
    return (height + 15);
}
@end
