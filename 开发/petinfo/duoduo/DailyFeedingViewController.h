//
//  DailyFeedingViewController.h
//  宠信
//
//  Created by tenyea on 14-8-14.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
/**
 日常饲养
 
 :param: idinitWithKnowledgeListId id
 */
@interface DailyFeedingViewController : TenyeaBaseViewController <UITextViewDelegate>

-(id)initWithKnowledgeListId:(NSString *)KnowledgeListId;
@end
