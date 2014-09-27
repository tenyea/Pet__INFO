//
//  MyAskDetailTopCell.h
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAskDetailTopCell : UITableViewCell
@property (nonatomic,strong ) NSDictionary *dic;

+(float) getCellHeight : (NSDictionary *)dic;

@property (strong, nonatomic) UIView *bottomView;
//内容
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *petImageVIew;
@property (strong, nonatomic) UILabel *petName;
@property (strong, nonatomic) UILabel *askTime;
@end
