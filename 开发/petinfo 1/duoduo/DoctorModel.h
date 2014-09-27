//
//  DoctorModel.h
//  宠信
//
//  Created by tenyea on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BaseModel.h"

@interface DoctorModel : BaseModel


@property (strong,nonatomic) NSString *docId;//id
@property (strong,nonatomic) NSString *docName;//医生名
@property (strong,nonatomic) NSString *docTitle;//职位
@property (strong,nonatomic) NSString *docSpec;//专长
@property (strong,nonatomic) NSString *docPhotoMin;//头像


@end
