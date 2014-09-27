//
//  PostModel.h
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BaseModel.h"

@interface PostModel : BaseModel
@property (nonatomic,strong ) NSString *petPhotoId;//id
@property (nonatomic,strong ) NSString *petPhotoTime ;//发帖时间
@property (nonatomic,strong) NSString *petPhotoTitle;//帖子标题
@property (nonatomic,strong) NSString *userName;//发帖人昵称
@property (nonatomic,strong) NSString *userHead;//发帖人头像
@property (nonatomic,strong) NSNumber *petPhotoDis;//回帖数
@property (nonatomic,strong) NSNumber *petPhotoGood;//点赞数
@end
