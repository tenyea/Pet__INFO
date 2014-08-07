//
//  PetKnowledgeViewController.m
//  宠信
//
//  Created by __ on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetKnowledgeViewController.h"
#import "LikePetCell.h"
#import "StoryContentViewController.h"
@interface PetKnowledgeViewController ()

@end

@implementation PetKnowledgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,480) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    
    [self.view addSubview:tableView];
}
// 设置一个表单中有多少分组(非正式协议如果不实现该方法则默认只有一个分组)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 设置一个分组中有多少行(必须实现的正式协议)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *likePetCellIdentifier = @"LikePetCellIdentifier";
    LikePetCell *cell = [tableView dequeueReusableCellWithIdentifier:likePetCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LikePetCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.navigationController pushViewController:[[StoryContentViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
