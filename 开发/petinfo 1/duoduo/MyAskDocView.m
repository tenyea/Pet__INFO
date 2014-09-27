//
//  MyAskDocView.m
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskDocView.h"
#import "UIImageView+AFNetworking.h"

@implementation MyAskDocView
-(void)awakeFromNib{
    
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    _docNameLabel.text =  [dic objectForKey:@"docName"];
    _positionLabel.text =  [dic objectForKey:@"docTitle"];
    [_docImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"docHead"] ]]  ;
    _anwserTIme.text =  [dic objectForKey:@"replyTime"];
}

@end
