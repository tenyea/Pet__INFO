//
//  TenyeaBaseHosViewController.h
//  宠信
//
//  Created by tenyea on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface TenyeaBaseHosViewController : TenyeaBaseViewController <UITableViewDataSource,UITableViewDelegate>
-(id)initWithHosId:(NSString *)HosId;
@property (nonatomic,strong) NSString *HosId;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@end
