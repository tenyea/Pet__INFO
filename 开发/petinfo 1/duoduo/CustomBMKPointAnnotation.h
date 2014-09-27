//
//  CustomBMKPointAnnotation.h
//  宠信
//
//  Created by tenyea on 14-8-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BMKPointAnnotation.h"
/**
 *  自定义的点标注，有存放数据的功能
 */
@interface CustomBMKPointAnnotation : BMKPointAnnotation

@property (nonatomic,strong) NSDictionary *userInfo;
@end
