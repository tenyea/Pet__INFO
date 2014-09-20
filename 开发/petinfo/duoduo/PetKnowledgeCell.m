//
//  PetKnowledgeCell.m
//  宠信
//
//  Created by tenyea on 14-8-14.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetKnowledgeCell.h"
#import "UIImageView+AFNetworking.h"
@implementation PetKnowledgeCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
        [self.leftImageVIew setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"knowledgeListImg"]]];
        self.titleLabel.text = [_dic objectForKey:@"knowledgeListTitle"];
        self.contentLabel.text = [_dic objectForKey:@"knowledgeListDes"];
    }
}
@end
