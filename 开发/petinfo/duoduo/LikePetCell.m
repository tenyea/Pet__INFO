//
//  LikePetCell.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "LikePetCell.h"
#import "UIImageView+WebCache.h"
@implementation LikePetCell
@synthesize imageView;
@synthesize likeLabel,lookLabel,titleLable,contentLabel;

-(void)awakeFromNib{
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius=38;
}
/**
 *  填充数据
 *
 *  @param dic 传入的数据
 */
-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        
        self.titleLable.text=[_dic objectForKey:@"petPhotoTitle"];
        self.contentLabel.text=[_dic objectForKey:@"petPhotoDes"];
        NSString *stringInt = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoGood"]];
        NSString *stringInt1 = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"petPhotoView"]];
        
        
        self.lookLabel.text=stringInt1;
        self.likeLabel.text=stringInt;
    
        NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"petPhotoImg"]];
        [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
        

    }
}
@end
