//
//  StoryViewController.h
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
typedef enum {
	TopViewStateBegin = 1, // 开始状态
	TopViewStateMove = 2, // 移动中
	TopViewStateEnd = 3, // 结束态
} TopViewState;

#import "TenyeaBaseViewController.h"
#import "ShowPetCell.h"
/**
 *  故事页
 */
@interface StoryViewController : TenyeaBaseViewController <UITableViewDataSource,UITableViewDelegate,pushVCDelegate>
{
    UITableView *_tableView;
}
@property (strong,nonatomic) UITableView *tableView;
/**
 *  刷新故事页内容
 */
-(void)refreshData;


@property (assign , nonatomic) TopViewState state;
@end
