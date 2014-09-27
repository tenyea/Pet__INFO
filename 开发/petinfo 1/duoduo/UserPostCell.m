//
//  UserPostCell.m
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UserPostCell.h"
#import "UIImageView+AFNetworking.h"
@implementation UserPostCell

-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        self.cusTextLabel.text = [_dic objectForKey:@"petPhotoText"];
        [_cusImageView setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"petPhotoPath"]]];
        _cusImageView.hidden = YES;

    }
}
-(void)showImage{
    [UIView animateWithDuration:.3 animations:^{
        self.buttonImage.transform =CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
    }];
    [self.cusImageView setHidden:NO];
    


}
-(void)hiddenImage{
    [UIView animateWithDuration:.3 animations:^{
        self.buttonImage.transform = CGAffineTransformIdentity;
        
    }];
    [self.cusImageView setHidden:YES];
    

}




@end
