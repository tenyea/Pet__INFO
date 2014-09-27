//
//  HospitalModel.h
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BaseModel.h"

@interface HospitalModel : BaseModel
@property (strong,nonatomic) NSString *hosId;//id
@property (strong,nonatomic) NSString *hosName;//医院名
@property (strong,nonatomic) NSString *hosAdd;//地址
@property (strong,nonatomic) NSString *hosPhone;//电话
@property (strong,nonatomic) NSString *hosLogo;//logo
@property (strong,nonatomic) NSString *hosStar;//评分
@property (strong,nonatomic) NSString *hosImage;//背景大图

@end
