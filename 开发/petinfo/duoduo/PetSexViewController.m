//
//  PetSexViewController.m
//  宠信
//
//  Created by tenyea on 14-7-16.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetSexViewController.h"

@interface PetSexViewController ()
{
    int _select;
    int _type;
    NSString *_userDefaults_name;
    NSString *_keyName ;
}
@end

@implementation PetSexViewController
-(id)initWithType :(int) type{
    self = [super init];
    if (self) {
        _type = type;
        if (type == 0 ) {
            _userDefaults_name = UD_petInfo_temp_PetModel;
            _keyName = @"petSex";
        }else{
            _userDefaults_name = UD_userInfo_temp_DIC;
            _keyName = @"userSex";
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"性别";
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:bgView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 44*2) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    NSString *sexStr =[[[NSUserDefaults standardUserDefaults]dictionaryForKey:_userDefaults_name] objectForKey:_keyName];
    _select = sexStr == nil ? 0 :[sexStr intValue];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)returnAction{
    [self popVC];
}
-(void)submitAction{
    [self popVC];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        if (_type == 0 ) {
            cell.textLabel.text = @"公";
        }else{
            cell.textLabel.text = @"男";
        }
    }else if (indexPath.row == 1) {
        if (_type == 0) {
            cell.textLabel.text = @"母";
        }else{
            cell.textLabel.text = @"女";
        }
    }
    if (indexPath.row ==_select ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow: _select inSection:0];
    UITableViewCell *desCell = [tableView cellForRowAtIndexPath:index];
    desCell.accessoryType = UITableViewCellAccessoryNone;
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _select = indexPath.row;
    [self performSelector:@selector(popVC) withObject:nil afterDelay:.2];
    
}
-(void)popVC {
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:_userDefaults_name ];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [muDic setValue:[NSString stringWithFormat:@"%d",_select] forKey:_keyName];
    [[NSUserDefaults standardUserDefaults]setValue:muDic forKeyPath:_userDefaults_name];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //    返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];

}
@end
