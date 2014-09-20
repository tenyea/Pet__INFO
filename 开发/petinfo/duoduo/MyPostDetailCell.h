//
//  MyPostDetailCell.h
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
@protocol reActionDelegate <NSObject>
-(void)reAction:(NSString *)petPhotoDisId  userName:(NSString *)userName;
@end
#import <UIKit/UIKit.h>

@interface MyPostDetailCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,strong) NSDictionary *dic ;
+(float) getCellHeight : (NSDictionary *)dic;
- (IBAction)userInfoAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *buildingNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *reBuildingNoLabel;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UITextView *reContentTextView;
@property (nonatomic,strong) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reUserNameLabel;
@property (strong, nonatomic) IBOutlet UIView *returnView;
- (IBAction)returnAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *userButton;

@property (strong, nonatomic) IBOutlet UIView *returnContentView;
@property (strong, nonatomic) IBOutlet UILabel *reTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) id<reActionDelegate> eventDelegate;
@end
