//
//  MyPostCell.h
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PostModel;
@interface MyPostCell : UITableViewCell

@property (nonatomic, strong) PostModel *model;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *petName;
@property (strong, nonatomic) IBOutlet UILabel *postTime;
@property (strong, nonatomic) IBOutlet UIImageView *petImageView;

@property (strong, nonatomic)  UIImageView *askCount;
@property (strong, nonatomic)  UILabel *askCountLabel;
@property (strong, nonatomic)  UIImageView *goodCount;
@property (strong, nonatomic)  UILabel *goodCountLabel;

@end
