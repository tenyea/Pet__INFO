//
//  ShowBMKAnnotationView.h
//  宠信
//
//  Created by tenyea on 14-8-20.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "BMKAnnotationView.h"
/**
 *  显示的标注点视图
 */
@interface ShowBMKAnnotationView : BMKAnnotationView

@property (nonatomic,strong) UILabel *label;

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
