//
//  HospitalCell.h
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HospitalModel;
@interface HospitalCell : UITableViewCell


@property (strong, nonatomic) UIImageView *starImageView;

@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) HospitalModel *model;
@end
