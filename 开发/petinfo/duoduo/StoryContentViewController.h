//
//  StoryContentViewController.h
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface StoryContentViewController : TenyeaBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@property (nonatomic,copy)NSString *petPresentation;
@property (nonatomic,copy)NSString *petImageViewURL;
@property (nonatomic,copy)NSString *photoID;
- (IBAction)commentsButton:(id)sender;
- (IBAction)likeButton:(id)sender;
- (IBAction)shareButton:(id)sender;

@end
