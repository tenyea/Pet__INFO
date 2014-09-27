//
//  InquiryModel.h
//  宠信
//
//  Created by tenyea on 14-7-26.
//  Copyright (c) 2014年 zzw. All rights reserved.
//  问诊

#import "BaseModel.h"

@interface InquiryModel : BaseModel
@property (nonatomic,strong ) NSString *postId;//id
@property (nonatomic,strong ) NSString *postTime;//问诊事件
@property (nonatomic,strong) NSString *userName;//用户昵称
@property (nonatomic,strong) NSString *userHead;//头像
@property (nonatomic,strong) NSString *postTitle;//标题
@property (nonatomic,strong) NSNumber *replyCount;//回复数
@property (nonatomic,strong) NSString *petName;//宠物名
@end
