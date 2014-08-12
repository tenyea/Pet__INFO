//
//  PetClassificationViewController.m
//  宠信
//
//  Created by __ on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetClassificationViewController.h"
#import "PetKnowledgeViewController.h"
@interface PetClassificationViewController ()

@end

@implementation PetClassificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,270) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled=NO;
    
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
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName= @"cell";
    // 声明cell并去复用池中找是否有对应标签的闲置cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    // 如果没找到可复用的cell
    if(cell == nil)
    {
        // 实例化新的cell并且加上标签
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] ;
        if (indexPath.row==0) {
            cell.textLabel.text=@"猫猫";
        }else if(indexPath.row==1)
        {
            cell.textLabel.text=@"狗狗";
        }else if(indexPath.row==2)
        {
            cell.textLabel.text=@"兔兔";
        }else if(indexPath.row==3)
        {
            cell.textLabel.text=@"鼠鼠";
        }

        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 设置cell被选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
        [self.navigationController pushViewController:[[PetKnowledgeViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
