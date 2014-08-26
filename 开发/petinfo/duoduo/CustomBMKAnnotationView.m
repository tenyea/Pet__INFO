//
//  CustomBMKAnnotationView.m
//  宠信
//
//  Created by tenyea on 14-8-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "CustomBMKAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
//箭头高
#define  Arror_height 6
@implementation CustomBMKAnnotationView
@synthesize contentView;
@synthesize customView;
-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 235, 75);
        self.canShowCallout = NO;
        
        
        
        UIView *_contentView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, self.width - 15, self.height - 15)];
        _contentView.backgroundColor = CLEARCOLOR;
        [self addSubview:_contentView];
        self.contentView = _contentView;
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity  = 1.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
}

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, COLOR(255, 255, 255).CGColor );
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context  {
    CGRect rrect = self.bounds;
//    半径弧度
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect) - Arror_height;
//   画箭头
    CGContextMoveToPoint(context, midx + Arror_height , maxy);
    CGContextAddLineToPoint(context, midx , maxy + Arror_height);
    CGContextAddLineToPoint(context, midx - Arror_height, maxy);
    
//    画边框
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
    
}
@end
