//
//  MyReplyViewController.h
//  宠信
//
//  Created by tenyea on 14-9-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface MyReplyViewController : TenyeaBaseViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *bottomViewTitle;

@end
