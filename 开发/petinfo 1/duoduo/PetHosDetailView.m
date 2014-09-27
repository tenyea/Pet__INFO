//
//  PetHosDetailView.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetHosDetailView.h"
#import "UIImageView+AFNetworking.h"
#import "HospitalModel.h"
@implementation PetHosDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    centerPoint = @[[NSNumber numberWithFloat:_hospButton.center.x],[NSNumber numberWithFloat:_userButton.center.x],[NSNumber numberWithFloat:_myButton.center.x]];
    
    _sliderView  = [[UIView alloc] initWithFrame: CGRectMake(0, 35, 60, 5)];
    _sliderView.backgroundColor = [UIColor colorWithRed:0.48 green:0.89 blue:0.86 alpha:1];
    [_bottomView insertSubview:_sliderView atIndex:NSIntegerMax -5];
    CGPoint p = _sliderView.center;
    p.x = [centerPoint[0] floatValue];
    _sliderView.center = p;
    _selected = 0;
    [_hospButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_userButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_myButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    _hospButton.selected = YES;
}

-(void)setModel:(HospitalModel *)model{
    [_hosLogo setImageWithURL:[NSURL URLWithString:model.hosLogo]];
    [_titleLabel setText:model.hosName];
    [_addLabel setText:model.hosAdd];
    [_phoneLabel setText:model.hosPhone];
}
- (IBAction)selectAction:(UIButton *)sender {
    
    UIButton *button = (UIButton *)VIEWWITHTAG(_bottomView, _selected + 1300);
    button.selected = NO;
    sender.selected = YES;
    _selected = sender.tag - 1300 ;
    CGPoint p = _sliderView.center;
    p.x = [centerPoint[_selected] floatValue];
    _sliderView.center = p;

    if ([self.eventDelegate respondsToSelector:@selector(selectedAction:)]) {
        [self.eventDelegate selectedAction:_selected];
    }
}
@end
