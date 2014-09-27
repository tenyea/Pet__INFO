//
//  EnvironmentCell.h
//  宠信
//
//  Created by tenyea on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnvironmentCell : UITableViewCell
{
    NSDictionary *_leftDic;
    NSDictionary *_rightDic;
}
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) NSArray *arr;


@end
