//
//  LatestAskCell.m
//  宠信
//
//  Created by tenyea on 14-7-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "LatestAskCell.h"
#import "UIImageView+AFNetworking.h"
#import "DataCenter.h"
@implementation LatestAskCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 25;
}

-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        [_imageV setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"userHead"]]];
        NSString *date = [dic objectForKey:@"postTime"];
        _timeLabel.text = [DataCenter  intervalSinceNow:date];
        _titleLabel.text = [dic objectForKey:@"postTitle"];
        _authorLabel.text = [dic objectForKey:@"userName"];
    }
    
    
}

@end
