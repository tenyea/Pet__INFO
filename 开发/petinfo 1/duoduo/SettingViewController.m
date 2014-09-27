//
//  SettingViewController.m
//  宠信
//
//  Created by tenyea on 14-9-17.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "SettingViewController.h"
#import "UpdatePasswordVC.h"

@interface SettingViewController ()
{
    NSArray *nameArr;
    UITableView *_tableView;

}
@end

@implementation SettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通用设置";
    nameArr = @[@"修改密码",@""];
    _tableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth , ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, .01f)];
    [self.view addSubview: _tableView];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Action
//登出
-(void)logoutAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userInfo_DIC];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userID_Str];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userName_Str];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_pet_Array];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[UpdatePasswordVC alloc]init] animated:YES];
            break;
        case 1:
            [self logoutAction];

            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        static NSString *logoutIdentifier = @"logoutIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
        if ( cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutIdentifier];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth - 30, 44 - 10)];
            button.backgroundColor = [UIColor redColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 8;
            [button setTitle:@"退出登录" forState:UIControlStateNormal ];
            [button addTarget: self  action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        return cell;
    }else{
        static NSString *editUserInfoIdentifier = @"editUserInfoIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editUserInfoIdentifier];
            
        }
        cell.textLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = nameArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}
@end
