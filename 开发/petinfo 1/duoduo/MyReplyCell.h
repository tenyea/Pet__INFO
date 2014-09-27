//
//  MyReplyCell.h
//  宠信
//
//  Created by tenyea on 14-9-12.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReplyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postContentLabel;
@property (strong, nonatomic) IBOutlet UIButton *userButton;

@property (strong, nonatomic) IBOutlet UILabel *replyLabel;
@property (strong, nonatomic) IBOutlet UIButton *postButton;

@property (assign, nonatomic) BOOL MyReply;
@property (strong, nonatomic) NSDictionary *dic ;

- (IBAction)postAction:(id)sender;
- (IBAction)userAction:(id)sender;

@end
