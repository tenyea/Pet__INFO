//
//  UserInfoDetailViewController.h
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface UserInfoDetailViewController : TenyeaBaseViewController <UITableViewDataSource,UITableViewDelegate>

-(id)initWithUserId:(NSString *)userId;
@end
