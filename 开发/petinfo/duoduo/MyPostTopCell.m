//
//  MyPostTopCell.m
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostTopCell.h"
#import "UserInfoDetailViewController.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@implementation MyPostTopCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        
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
//    头像
    NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"petPhotoPostUserHead"]];

//    [_userInfoButton setImageWithURL:url forState:UIControlStateNormal];
    [_userInfoButton setImageForState:UIControlStateNormal withURL:url];

//    用户名
    _userNameLabel.text = [_dic objectForKey:@"petPhotoPostUserName"];
    [_userNameLabel sizeToFit];
//    右上角
    _bottomView.top = 12 ;
    _bottomView.height = 14;
    
    NSNumber *askCount = [_dic objectForKey:@"petPhotoDis"];
    NSNumber *goodCount = [_dic objectForKey:@"petPhotoGood"];
    _askCountLabel.text = [askCount stringValue];
    _goodCountLabel.text = [goodCount stringValue];
//    调整左下角位置
    [_goodCountLabel sizeToFit];
    [_askCountLabel sizeToFit];

    _goodCount.left = 3;
    _goodCountLabel.left = _goodCount.right + 3;
    _askCount.left = _goodCountLabel.right + 6;
    _askCountLabel.left = _askCount.right + 3;
    _bottomView.width = _askCountLabel.right;
    _bottomView.right = ScreenWidth - 10;
    
//    文字内容
    NSString *str = [_dic objectForKey:@"petPhotoText"];
    _contentTextView.text = str;
    _contentTextView.delegate = self;
    CGSize size = [str  boundingRectWithSize:CGSizeMake(234 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
    _contentTextView.height = size.height+ 12;
    _petImageView.top = _contentTextView.bottom;

//  图片展示
    [_petImageView setImageWithURL: [NSURL URLWithString:[_dic objectForKey:@"petPhotoPath"]]];

    //转换时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *askTime = [_dic objectForKey:@"petPhotoPostTime"] ;
    NSDate *date  = [dateFormatter dateFromString:askTime];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];
    _timeLabel.top = _petImageView.bottom + 15;
    
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
+(float) getCellHeight : (NSDictionary *)dic{
    if (dic) {
        NSString *content = [dic objectForKey:@"petPhotoText"];
        CGSize size = [content  boundingRectWithSize:CGSizeMake(234 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
        
        float height = size.height + 12  + 128 + 29 + 5 + 12 +14;//内容高+留白 +图片高 + textTop + 底部图片留白 + 时间 + 留白
        return height;
    }else{
        return 0;
    }
}

- (IBAction)userInfoAction:(id)sender {
    NSString *userId = [_dic objectForKey:@"petPhotoUserId"];
    [self.viewController.navigationController pushViewController:[[UserInfoDetailViewController alloc] initWithUserId:userId] animated:YES];

}
@end
