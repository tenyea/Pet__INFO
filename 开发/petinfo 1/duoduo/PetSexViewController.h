//
//  PetSexViewController.h
//  宠信
//
//  Created by tenyea on 14-7-16.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface PetSexViewController : TenyeaBaseViewController <UITableViewDataSource,UITableViewDelegate>

-(id)initWithType :(int) type;//0 宠物，1 人
@end
