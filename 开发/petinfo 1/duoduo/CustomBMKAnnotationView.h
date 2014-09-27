//
//  CustomBMKAnnotationView.h
//  宠信
//
//  Created by tenyea on 14-8-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BMKAnnotationView.h"
#import "CustomView.h"
/**
 用于显示的标注点。添加了小箭头
 
 :param: idinitWithAnnotation 
 */
@interface CustomBMKAnnotationView : BMKAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,strong) CustomView *customView;


@property (nonatomic,strong) UIView *contentView;
@end
