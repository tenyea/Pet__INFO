//
//  CustomView.h
//  宠信
//
//  Created by tenyea on 14-8-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 自定义的显示view
@interface CustomView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNickName;

@property (strong,nonatomic) NSDictionary *userInfo;

@end
