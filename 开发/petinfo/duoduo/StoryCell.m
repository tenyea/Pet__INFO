//
//  StoryCell.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "DataCenter.h"
#define spacing 2
@implementation StoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
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
//        时间
        NSString *time = [_dic objectForKey:@"petPhotoTime"];
        self.TimeLabel.text= [DataCenter intervalSinceNow:time];
        [self.TimeLabel sizeToFit];
//        标题
        self.TitleLabel.text=[_dic objectForKey:@"petPhotoDes"];
//        self.TitleLabel.text = @"123jflsdakjflasdkfj;asldkfj;alsdfjlkasdjfalsdkfj;afka;dsfjasl;dfjasdl;fkjsad;lkfjsaldkfjasldkfj;lajflds;kfjsldakjfs;ladkfjalskdjflaksdjfl;askdfjlasdkjfls;adkfjsldkafjasldkfj;askdfjlskadfjlasdkfjsldkfjsaldkfjsldkfjas;";

        CGSize size = [self.TitleLabel.text boundingRectWithSize:CGSizeMake(252, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
        self.TitleLabel.height = size.height;
        self.contentBgVIew.height = size.height + 5 + 15 + 100 + 10 ;
//        内容图片
        self.contentImage.top = self.TimeLabel.height + 10;
        
//        用户名
        self.UserNameLabel.text=[_dic objectForKey:@"userName"];
        [self.UserNameLabel sizeToFit];
//        是否显示hot
        if (_isShowHot) {
            self.hotImage.hidden = NO;
            self.hotImage.left = self.UserNameLabel.right + 5;
            [self.contentImage setImageWithURL: [NSURL URLWithString:[_dic objectForKey:@"petPhotoPathMax"]]];

        }else{
            [self.contentImage setImageWithURL: [NSURL URLWithString:[_dic objectForKey:@"petPhotoImgMax"]]];

        }
//        头像
        NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"userHead"]];
        [self.ImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"my_petlogo.png"]];
        //        设置点赞和回复
        self.returnMsgLabel.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoView"]];
        [self.returnMsgLabel sizeToFit];
        self.returnMsgLabel.right = self.goodAndReturnBg.width - spacing*3;
        self.returnImage.right = self.returnMsgLabel.left - spacing;
        self.goodLabel.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoGood"]];
        [self.goodLabel sizeToFit];
        self.goodLabel.right = self.returnImage.left - spacing *8;
        self.goodImage.right = self.goodLabel.left - spacing;
        self.goodAndReturnBg.top = self.contentBgVIew.height -15;
        self.goodAndReturnBg.height = 15;
    }
}
+(float)getCellHeigh:(NSDictionary *)dic{
    float height = 0.0;
    CGSize size = [[dic objectForKey:@"petPhotoTitle"] boundingRectWithSize:CGSizeMake(272, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
    height = size.height + 5 + 15 + 100 + 31 + 5 + 10;
    return height;
}
@end
