//
//  ShowBMKAnnotationView.m
//  宠信
//
//  Created by tenyea on 14-8-20.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ShowBMKAnnotationView.h"

@implementation ShowBMKAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 35, 35);
        self.canShowCallout = NO;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame ];
        [imageView setImage: [UIImage imageNamed:@"story_map_annotation.png"]];
        [self addSubview:imageView];
        
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FONT(12);
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];

    }
    
    return self;
}

@end
