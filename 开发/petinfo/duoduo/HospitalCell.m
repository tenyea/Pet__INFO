//
//  HospitalCell.m
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "HospitalCell.h"
#import "UIImageView+WebCache.h"
#import "HospitalModel.h"
@implementation HospitalCell

- (void)awakeFromNib
{
//    [super awakeFromNib ];
    self.leftImageView.layer.masksToBounds = YES;
    self.leftImageView.layer.cornerRadius = 39;
    
    UIImageView *grayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(253, 64, 50, 12)];
    [grayImageView setImage:[UIImage imageNamed:@"ask_gray_start.png"]];
    [self.contentView addSubview:grayImageView];
    
    _starImageView = [[UIImageView alloc]initWithFrame:CGRectMake(253, 64, 0, 12)];
    [self.contentView addSubview:_starImageView];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:self.model.hosLogo]];
    self.nameLabel.text = self.model.hosName;
    self.addressLabel.text = self.model.hosAdd;
    self.phoneLabel.text = self.model.hosPhone;
    
    float score = [self.model.hosStar  floatValue] * 20;
    if (score == 0) {
        _starImageView.width = 0;
    }else{
        UIImage *image = [UIImage imageNamed:@"ask_yellow_start.png"];
        UIImage *newImage = [self getImage:image rect:CGSizeMake(score, 24)];
        
        _starImageView.width = score /2;
        [_starImageView setImage: newImage];
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
