//
//  PetKnowledgeViewController.m
//  宠信
//
//  Created by __ on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetKnowledgeViewController.h"
#import "PetKnowledgeCell.h"
#import "StoryContentViewController.h"
#import "DailyFeedingViewController.h"
@interface PetKnowledgeViewController ()
{
    NSString *_type;
    NSString *_kindId;
    int _board;//模板类型
    UITableView *_tableView;
    NSArray *_dataArr;
}
@end

@implementation PetKnowledgeViewController
-(id)initWithType:(NSString *)type KindId:(NSString *)kindId board :(int) board{
    if (self = [super init]) {
        _type = type;
        _kindId = kindId;
        _board = board;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIScrollView *bgScView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: bgScView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64-35, ScreenWidth, ScreenHeight - 64 + 35 -15) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (_type) {
        [params setObject:_type forKey:@"type"];
    }
    if (_kindId) {
        [params setObject:_kindId forKey:@"kindId"];
    }
    [self getDate:URL_getKnowledgeList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _dataArr = [responseObject objectForKey:@"knowledgeList"];
            if (_dataArr.count > 0 ) {
                [_tableView reloadData];
            }else{
                self.bgStr = @"暂时还未添加";
            }
        }else
        {
            self.bgStr = Tenyea_str_load_error;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];

}

// 设置一个分组中有多少行(必须实现的正式协议)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_board == 0 ) {
        return 60;
    }else {
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_board == 0) {
        static NSString *petKnowledgeIdentifier = @"petKnowledgeIdentifier";
        PetKnowledgeCell *cell = (PetKnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:petKnowledgeIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PetKnowledgeCell" owner:self options:nil]lastObject];
        }
        cell.dic = _dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
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
        cell.textLabel.text = [dic objectForKey:@"knowledgeListTitle"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *knowledgeListId =[_dataArr[indexPath.row] objectForKey:@"knowledgeListId" ];
    if (_board == 0 ) {
        [self.navigationController pushViewController:[[StoryContentViewController alloc] initWithID:knowledgeListId hasComments:NO] animated:YES];
    }else{
        [self.navigationController pushViewController:[[DailyFeedingViewController alloc]initWithKnowledgeListId:knowledgeListId] animated:YES];
    }
}


@end
