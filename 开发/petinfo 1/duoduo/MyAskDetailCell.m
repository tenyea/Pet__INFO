//
//  MyAskDetailCell.m
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskDetailCell.h"

@implementation MyAskDetailCell

- (void)awakeFromNib
{
//    回答内容
    _anwserContent = [[UITextView alloc]initWithFrame: CGRectMake(37, 0, 269, 0)];
    _anwserContent.showsHorizontalScrollIndicator = NO;
    _anwserContent.showsVerticalScrollIndicator = NO;
    [_anwserContent setFont: FONT(17)];
    _anwserContent.userInteractionEnabled = YES;
    _anwserContent.bounces = NO;//    禁用键盘
    [_anwserContent setEditable: NO];
    [self addSubview:_anwserContent];

}

-(void)setContent:(NSString *)content{
    if (![_content isEqualToString:content]) {
        _content = content;
        [self setNeedsDisplay];
    }
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _anwserContent.text = _content;
    CGSize size = [_content boundingRectWithSize:CGSizeMake(269, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(17)} context:nil].size;
    _anwserContent.height = size.height + 40;
    

}
+(float) getCellHeight : (NSString *)content{
    float height = 0.0;
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(269, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(17)} context:nil].size;
    height = size.height + 40;
    return height;
}
@end
