//
//  PetHosDetailView.h
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
@protocol PetHosDetailViewDelegate <NSObject>

-(void)selectedAction:(int)tag;

@end
#import <UIKit/UIKit.h>
@class HospitalModel;
@interface PetHosDetailView : UIView{
    NSArray *centerPoint;
    int _selected;
}

@property (nonatomic,strong ) HospitalModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *hosLogo;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)selectAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *myButton;

@property (strong, nonatomic) IBOutlet UIButton *hospButton;
@property (strong, nonatomic) IBOutlet UIView *bottomView;


@property (strong, nonatomic)  UIView *sliderView;//滑动块
@property (nonatomic,weak) id<PetHosDetailViewDelegate> eventDelegate;
@end
