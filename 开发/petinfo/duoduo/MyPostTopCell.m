//
//  MyPostTopCell.m
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostTopCell.h"
#import "UIImageView+WebCache.h"
@implementation MyPostTopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        _userNameLabel  = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, 70, 15)];
        _userNameLabel.textColor = [UIColor colorWithRed:0.78 green:0.65 blue:0.35 alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_userNameLabel];
        
        _contentLabel  = [[UILabel alloc] initWithFrame: CGRectMake(80, 10, ScreenWidth - 10 - 80, 15)];
        _contentLabel.textColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _petImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 15, ScreenWidth - 20 , 220)];
        [self.contentView addSubview:_petImageView];
        
        _bottomView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, 15)];
        [self.contentView addSubview:_bottomView];
        
        
        
        _timeLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 0, 80, 15)];
        _timeLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:_timeLabel];
        
        
        
        
        _askCount = [[UIImageView alloc]initWithFrame:CGRectMake(244, 0 , 15 , 15)];
        [_askCount setImage:[UIImage imageNamed:@"my_askcount.png"]];
        [_bottomView addSubview:_askCount];
        _goodCount = [[UIImageView alloc]initWithFrame:CGRectMake(276, 0, 15 , 15)];
        [_goodCount setImage:[UIImage imageNamed:@"my_goodcount.png"]];
        [_bottomView addSubview:_goodCount];
        
        _askCountLabel = [[UILabel alloc]initWithFrame: CGRectMake(261, 0, 60, 15)];
        _askCountLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
        _askCountLabel.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:_askCountLabel];
        _goodCountLabel = [[UILabel alloc]initWithFrame: CGRectMake(293, 0, 60, 15)];
        _goodCountLabel.textColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
        _goodCountLabel.font = [UIFont systemFontOfSize:12];
        [_bottomView addSubview:_goodCountLabel];
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
    NSNumber *askCount = [_dic objectForKey:@"petPhotoDis"];
    NSNumber *goodCount = [_dic objectForKey:@"petPhotoGood"];
    _askCountLabel.text = [askCount stringValue];
    _goodCountLabel.text = [goodCount stringValue];
//    调整左下角位置
    [_goodCountLabel sizeToFit];
    [_askCountLabel sizeToFit];
    _goodCountLabel.right = 320 - 15;
    _goodCount.right = _goodCountLabel.left - 5;
    _askCountLabel.right = _goodCount.left - 5;
    _askCount.right = _askCountLabel.left - 5;
    
    //转换时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = [_dic objectForKey:@"petPhotoPostTime"] ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];
    
    _userNameLabel.text = [_dic objectForKey:@"petPhotoPostUserName"];
    
    NSString *str = [_dic objectForKey:@"petPhotoText"];
    _contentLabel.text = str;
    CGSize size = [str  boundingRectWithSize:CGSizeMake(ScreenWidth - 15 *2 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    _contentLabel.height = size.height;
    
    [_petImageView setImageWithURL: [NSURL URLWithString:[_dic objectForKey:@"petPhotoPath"]]];
    _bottomView.top = size.height + 5 + 220 + 5;
}

+(float) getCellHeight : (NSDictionary *)dic{
    if (dic) {
        NSString *content = [dic objectForKey:@"petPhotoText"];
        CGSize size = [content  boundingRectWithSize:CGSizeMake(ScreenWidth - 15 *2 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
        
        float height = size.height + 5 + 220 + 5 + 15 +5 ;//内容高+留白 +图片高+留白+底部视图 + 留白
        return height;
    }else{
        return 0;
    }
}
@end
