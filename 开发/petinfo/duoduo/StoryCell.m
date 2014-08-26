//
//  StoryCell.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryCell.h"
#import "UIImageView+WebCache.h"
@implementation StoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _init];
}
-(void)_init{
    _ImageView.layer.masksToBounds = YES;
    _ImageView.layer.cornerRadius = 38;
}
/*
-(void)drawRect:(CGRect)rect{
    
//    [super drawRect:rect];
    //获取画板
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);//线条颜色
    //设置填充的颜色
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextMoveToPoint(ctx, 52, 45);
    //    52 45 76 76
    CGContextAddRect(ctx, CGRectMake(52, 45, 76, 76));
    CGContextStrokePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);

}
*/


-(void)setDic:(NSDictionary *)dic {
    if (_dic != dic) {
        _dic = dic;
        self.TimeLabel.text=[_dic objectForKey:@"petPhotoTime"];
        self.TitleLabel.text=[_dic objectForKey:@"petPhotoTitle"];
        self.UserNameLabel.text=[_dic objectForKey:@"userName"];
        NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"userHead"]];
        [self.ImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];

    }
}

@end
