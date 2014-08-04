//
//  UserCommentCell.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//  用户评论

#import "UserCommentCell.h"

@implementation UserCommentCell

- (void)awakeFromNib
{
    _selectedStarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 1, 0, 12)];
    [self.contentView addSubview:_selectedStarImageView];
}

-(void)setDic:(NSDictionary *)dic{
    if (_dic !=dic) {
        _dic = dic;
        _contentLabel.text = [_dic objectForKey:@"hosDis"];
        _userLabel.text = [_dic objectForKey:@"userName"];
        float score = [[_dic objectForKey:@"hosStarScore"] floatValue] *20;
        if (score > 0) {
            UIImage *image = [UIImage imageNamed:@"ask_yellow_start.png"];
            UIImage *newImage = [self getImage:image rect:CGSizeMake(score, 24)];
            
            _selectedStarImageView.width = score /2;
            [_selectedStarImageView setImage: newImage];
        }
    }
}

//截取图片大小
- (UIImage *)getImage:(UIImage *)bigImage rect:(CGSize)reSize
{
    //截取截取大小为需要显示的大小。取图片中间位置截取
    CGRect myImageRect = CGRectMake(0, 0, reSize.width, reSize.height);
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    UIGraphicsBeginImageContext(reSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end
