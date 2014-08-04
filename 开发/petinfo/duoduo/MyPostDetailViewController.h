//
//  MyPostDetailViewController.h
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface MyPostDetailViewController : TenyeaBaseViewController<UITableViewDataSource,UITableViewDelegate>


-(id)initWithId:(NSString *)postId;
@end
