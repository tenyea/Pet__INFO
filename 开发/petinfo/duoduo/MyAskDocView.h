//
//  MyAskDocView.h
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAskDocView : UIView
@property (nonatomic,strong ) NSDictionary *dic;
@property (strong, nonatomic) IBOutlet UIImageView *docImageView;
@property (strong, nonatomic) IBOutlet UILabel *docNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *anwserTIme;

@end
