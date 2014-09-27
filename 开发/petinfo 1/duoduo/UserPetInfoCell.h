//
//  UserPetInfoCell.h
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPetInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *petImageButton;
- (IBAction)petInfoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *petNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *petKindLabel;

@property (strong, nonatomic) IBOutlet UILabel *petAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *petSexLabel;
@property (strong, nonatomic) IBOutlet UILabel *petVarietyLabel;

@property (strong, nonatomic) NSDictionary *dic;
@end
