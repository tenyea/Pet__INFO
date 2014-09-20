//
//  MyReplyBgView.m
//  宠信
//
//  Created by tenyea on 14-9-12.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyReplyBgView.h"
//箭头高
#define  Arror_height 6
@implementation MyReplyBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [COLOR(190, 190, 190) CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);

}
-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, COLOR(190, 190, 190).CGColor );
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context  {
    CGRect rrect = CGRectMake(5, 5, self.bounds.size.width- 10, self.bounds.size.height-6);
    //    半径弧度
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    //   画箭头
    CGContextMoveToPoint(context, 25  , miny );
    CGContextAddLineToPoint(context, 25 + Arror_height/2, minx - Arror_height);
    CGContextAddLineToPoint(context, 25 + Arror_height, miny);
    
    //    画边框
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextClosePath(context);
    
}
@end
