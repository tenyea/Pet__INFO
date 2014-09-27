//
//  MyAskDetailCell.h
//  宠信
//
//  Created by tenyea on 14-7-28.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAskDetailCell : UITableViewCell

@property (strong, nonatomic)  UITextView *anwserContent;
+(float) getCellHeight : (NSString *)content;
@property (strong, nonatomic) NSString *content;
@end
