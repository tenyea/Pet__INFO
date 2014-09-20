//
//  MyPostDetailViewController.h
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaNoBarVC.h"
#import "MyPostDetailCell.h"

@interface MyPostDetailViewController : TenyeaNoBarVC<UITableViewDataSource,UITableViewDelegate,reActionDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *bottomViewTitle;


-(id)initWithId:(NSString *)postId;
@end
