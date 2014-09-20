//
//  UserPostCell.h
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPostCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cusTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *buttonImage;

-(void)showImage;
-(void)hiddenImage;
@property (strong, nonatomic) NSDictionary *dic;
@end
