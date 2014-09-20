//
//  LikePetCell.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "LikePetCell.h"
#import "UIImageView+AFNetworking.h"
#import "DataCenter.h"
#define spacing 2

@implementation LikePetCell
@synthesize imageView;
@synthesize likeLabel,returnLabel,titleLable,contentLabel;

-(void)awakeFromNib{
//    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.cornerRadius=38;
}
/**
 *  填充数据
 *
 *  @param dic 传入的数据
 */
-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        
        self.titleLable.text=[_dic objectForKey:@"userName"];
        self.contentLabel.text=[_dic objectForKey:@"petPhotoDes"];
        NSString *stringInt = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoGood"]];
        NSString *stringInt1 = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoView"]];
        
        
        self.returnLabel.text=stringInt1;
        self.likeLabel.text=stringInt;
    
        self.timeLabel.text = [DataCenter intervalSinceNow:[_dic objectForKey:@"petPhotoTime"]];
        NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"userHead"]];
        [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"my_petlogo.png"]];
        
        
        [self.returnLabel sizeToFit];
        [self.likeLabel sizeToFit];
        self.returnLabel.right = self.contentView.width - spacing *3;
        self.returnImage.right = self.returnLabel.left - spacing;
        self.likeLabel.right = self.returnImage.left - spacing *8;
        self.likeImage.right = self.likeLabel.left - spacing;
        
    }
}
@end
