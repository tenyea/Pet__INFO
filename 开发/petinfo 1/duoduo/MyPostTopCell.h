//
//  MyPostTopCell.h
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostTopCell : UITableViewCell <UITextViewDelegate>


@property (nonatomic,strong) NSDictionary *dic ;

+(float) getCellHeight : (NSDictionary *)dic;

- (IBAction)userInfoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *userInfoButton;
@property (nonatomic,strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (nonatomic,strong) IBOutlet UIImageView *petImageView;
//底部视图
@property (nonatomic,strong) IBOutlet UIView  *bottomView ;

@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UIImageView *askCount;
@property (nonatomic,strong) IBOutlet UILabel *askCountLabel;
@property (nonatomic,strong) IBOutlet UIImageView *goodCount;
@property (nonatomic,strong) IBOutlet UILabel *goodCountLabel;
@end
