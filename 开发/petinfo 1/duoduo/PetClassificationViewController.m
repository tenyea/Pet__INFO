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
{
    NSString *_type;
    BOOL _secondType;
    UITableView *_tableView;
    
    NSArray *_dataArr;
    NSArray *_dataTemp;
}
@end

@implementation PetClassificationViewController

-(id)initWithType:(NSString *)type secondType:(BOOL)secondType{
    self = [super init];
    if (self) {
        _type = type;
        _secondType = secondType;
    }
    return self;
}
-(id)initWithType:(NSString *)type {
    self = [self initWithType:type secondType:NO];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataTemp = @[@{@"petSpeciesId": @"0",@"petSpeciesName":@"狗狗"},@{@"petSpeciesId": @"1",@"petSpeciesName":@"猫猫"},@{@"petSpeciesId": @"2",@"petSpeciesName":@"小宠"},@{@"petSpeciesId": @"3",@"petSpeciesName":@"水族"},@{@"petSpeciesId": @"4",@"petSpeciesName":@"其他"}];
	UIScrollView *bgScView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: bgScView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64-35, ScreenWidth, ScreenHeight - 64 + 35 -15) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    [self getDate:URL_getPetKind andParams:[[NSDictionary alloc]init] andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _dataArr = [responseObject objectForKey:@"petKind"];
            [_tableView reloadData];
        }else
        {
            _dataArr = _dataTemp;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _dataArr = _dataTemp;
        _po([error localizedDescription]);
    }];

}

// 设置一个分组中有多少行(必须实现的正式协议)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
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
    
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"petSpeciesName"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_secondType) {
        [self.navigationController pushViewController:[[PetKnowledgeViewController alloc] initWithType:_type KindId:[_dataArr[indexPath.row] objectForKey:@"petSpeciesId"] board:1] animated:YES];
    }else{
        [self.navigationController pushViewController:[[PetKnowledgeViewController alloc] initWithType:_type KindId:[_dataArr[indexPath.row] objectForKey:@"petSpeciesId"] board:0] animated:YES];
    }
}

@end
