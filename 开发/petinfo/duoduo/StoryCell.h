//
//  StoryCell.h
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 故事页排名视图
@interface StoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (strong, nonatomic) IBOutlet UIView *contentBgVIew;
/**
 *  回复
 */

@property (strong, nonatomic) IBOutlet UILabel *returnMsgLabel;
@property (strong, nonatomic) IBOutlet UIImageView *returnImage;
/**
 *  点赞数
 */
@property (strong, nonatomic) IBOutlet UILabel *goodLabel;
@property (strong, nonatomic) IBOutlet UIImageView *goodImage;
@property (strong, nonatomic) IBOutlet UIView *goodAndReturnBg;

@property (strong, nonatomic) IBOutlet UIImageView *hotImage;

@property (nonatomic ,strong) NSDictionary *dic ;
@property (nonatomic ,assign) BOOL isShowHot;

+(float)getCellHeigh:(NSDictionary *)dic;
@end
