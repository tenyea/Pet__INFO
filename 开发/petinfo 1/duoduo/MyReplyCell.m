//
//  MyReplyCell.m
//  宠信
//
//  Created by tenyea on 14-9-12.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyReplyCell.h"
#import "UIButton+AFNetworking.h"
#import "UserInfoDetailViewController.h"
#import "MyPostDetailViewController.h"
@implementation MyReplyCell

- (void)awakeFromNib
{

}
// @[@{@"headImage": @"",@"userName": @"1234",@"content": @"123123",@"relpyImage": @"",@"replycontent": @"44444"}];
-(void)setDic:(NSDictionary *)dic {
    if (_dic != dic) {
        _dic = dic;
        /**
         *  帖子图片
         */
        NSURL *postUrl = [NSURL URLWithString:[_dic objectForKey:@"petPhotoImg"]];
//        [_postButton setImageWithURL:postUrl forState:UIControlStateNormal];
        [_postButton setImageForState:UIControlStateNormal withURL:postUrl];
        /**
         *  回复者的头像
         */
        NSURL *userUrl = [NSURL URLWithString:[_dic objectForKey:@"petPhotoDisUserHead"]];
//        [_userButton setImageWithURL:userUrl forState:UIControlStateNormal];
        [_userButton setImageForState:UIControlStateNormal withURL:userUrl];
        //    回复内容
        _replyLabel.text = [_dic objectForKey:@"petPhotoDisText"];
        
        //        我的回复
        if (_MyReply) {
            [self myReply];
        }
//        回复我的
        else {
            [self ReplyToMe];
        }
        [self setNeedsDisplay];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _replyLabel.frame = CGRectMake(20, 6, 280, 80);
    [_replyLabel sizeToFit];

}
//我的回复
-(void)myReply {
//    中间字
//    评论
    if ([[_dic objectForKey:@"huifuUserName"] isEqualToString:@""]) {
        [self myPost];
    }
//    回复
    else {
        [self myReplyUser];
    }
}
//我评论帖子
-(void)myPost{
    NSString *userName = [_dic objectForKey:@"petPhotoUserName"];
    NSString *content = [_dic objectForKey:@"petPhotoText"];
    NSString *contentStr =[NSString stringWithFormat:@"我评论了%@的帖子:%@",userName,content];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //            默认字体颜色
    [attributeString addAttribute:NSForegroundColorAttributeName value:COLOR(80, 80, 80) range:NSMakeRange(0, attributeString.length)];
    //        字体大小
    [attributeString addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(0, attributeString.length)];
    //            用户名颜色
    NSRange userRange = [contentStr rangeOfString:userName];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.33 green:0.61 blue:0.9 alpha:1]  range: userRange];
    //            回复内容颜色
    NSRange contentRange = [contentStr rangeOfString:content options:NSBackwardsSearch];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1]  range: contentRange];
    
    _postContentLabel.attributedText = attributeString;

}
//我回复用户
-(void)myReplyUser{
    NSString *userName = [_dic objectForKey:@"huifuUserName"];
    NSString *content = [_dic objectForKey:@"huifuText"];
    NSString *contentStr =[NSString stringWithFormat:@"我回复了%@的评论:%@",userName,content];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //            默认字体颜色
    [attributeString addAttribute:NSForegroundColorAttributeName value:COLOR(80, 80, 80) range:NSMakeRange(0, attributeString.length)];
    //        字体大小
    [attributeString addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(0, attributeString.length)];
    //            用户名颜色
    NSRange userRange = [contentStr rangeOfString:userName];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.33 green:0.61 blue:0.9 alpha:1]  range: userRange];
    //            回复内容颜色
    NSRange contentRange = [contentStr rangeOfString:content options:NSBackwardsSearch];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1]  range: contentRange];
    
    _postContentLabel.attributedText = attributeString;
}

//回复我的
-(void)ReplyToMe{
    NSString *userName = [_dic objectForKey:@"petPhotoDisUserName"];
    NSString *content = [_dic objectForKey:@"huifuText"];
    NSString *contentStr =[NSString stringWithFormat:@"%@回复了我的评论:%@",userName,content];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //            默认字体颜色
    [attributeString addAttribute:NSForegroundColorAttributeName value:COLOR(80, 80, 80) range:NSMakeRange(0, attributeString.length)];
    //        字体大小
    [attributeString addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(0, attributeString.length)];
    //            用户名颜色
    NSRange userRange = [contentStr rangeOfString:userName];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.33 green:0.61 blue:0.9 alpha:1]  range: userRange];
    //            回复内容颜色
    NSRange contentRange = [contentStr rangeOfString:content options:NSBackwardsSearch];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1]  range: contentRange];
    
    _postContentLabel.attributedText = attributeString;

}
- (IBAction)postAction:(id)sender {
    [self.viewController.navigationController pushViewController:[[MyPostDetailViewController alloc] initWithId:[_dic objectForKey:@"petPhotoId"]] animated:YES];
}

- (IBAction)userAction:(id)sender {
    NSString *userId;
    //        我的回复
    if (_MyReply) {
        userId = [_dic objectForKey:@"petPhotoDisUserId"];
    }
    //        回复我的
    else {
        userId = [_dic objectForKey:@"huifuUserId"];
    }
    [self.viewController.navigationController pushViewController:[[UserInfoDetailViewController alloc]initWithUserId:userId] animated:YES];
}
@end
