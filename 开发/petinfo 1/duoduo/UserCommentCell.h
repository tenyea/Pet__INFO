//
//  UserCommentCell.h
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//  用户评论

#import <UIKit/UIKit.h>

@interface UserCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIImageView *startImageView;
@property (nonatomic,strong) NSDictionary *dic ;

@property (strong, nonatomic) UIImageView *selectedStarImageView;
@end
