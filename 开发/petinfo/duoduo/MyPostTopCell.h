//
//  MyPostTopCell.h
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPostTopCell : UITableViewCell


@property (nonatomic,strong) NSDictionary *dic ;

+(float) getCellHeight : (NSDictionary *)dic;

@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *petImageView;
//底部视图
@property (nonatomic,strong) UIView  *bottomView ;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *askCount;
@property (nonatomic,strong) UILabel *askCountLabel;
@property (nonatomic,strong) UIImageView *goodCount;
@property (nonatomic,strong) UILabel *goodCountLabel;
@end
