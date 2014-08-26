//
//  StoryCommentsViewController.h
//  宠信
//
//  Created by tenyea on 14-8-13.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaNoBarVC.h"
/**
 *  故事页评论页
 */
@interface StoryCommentsViewController : TenyeaNoBarVC <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITextView *textView;
-(id)initWithPetId:(NSString *)petPhotoId;
@end
