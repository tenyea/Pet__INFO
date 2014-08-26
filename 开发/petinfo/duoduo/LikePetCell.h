//
//  LikePetCell.h
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 人气排名视图
@interface LikePetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *lookLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;



@property (nonatomic ,strong) NSDictionary *dic ;
@end
