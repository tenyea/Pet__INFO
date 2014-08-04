//
//  MyPostDetailCell.h
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostDetailCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dic ;
+(float) getCellHeight : (NSDictionary *)dic;

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end
