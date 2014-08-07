//
//  AskViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "AskViewController.h"
#import "LatestAskCell.h"
#import "PetHospitalViewController.h"
#import "AskOnlineViewController.h"
#import "MJRefresh.h"
#import "MyAskDetailViewController.h"
@interface AskViewController ()
{
    NSArray *_titleArr;
    NSArray *_titleImageArr;
    NSArray *_dataArr;
    UITableView *_tableView;
}
@end

@implementation AskViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleArr = @[@"在线问诊",@"宠物医院"];
    _titleImageArr = @[@"ask_online.png",@"ask_hospital.png"];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self getDate:URL_getInquiryList andParams:[[NSDictionary alloc] init] andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            _dataArr = [responseObject objectForKey:@"postList"];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
//    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    下拉
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    
    [self getDate:URL_getInquiryList andParams:[[NSDictionary alloc] init] andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            if (_dataArr.count > 0 ) {
                _dataArr = [[NSArray alloc]init];
            }
            _dataArr = [responseObject objectForKey:@"postList"];
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [_tableView headerEndRefreshing];

    }];
}
//下拉 加载
-(void)footerRereshing{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (_dataArr.count > 0) {
        NSDictionary *dic = [_dataArr lastObject];
        NSString *lastId = [dic objectForKey:@"postId"];
        [params setObject:lastId forKey:@"lastId"];
    }
    
    [self getDate:URL_getInquiryList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
            
            NSArray *arr = [responseObject objectForKey:@"postList"];
            if (arr.count > 0) {
                [array  addObjectsFromArray:arr];
                _dataArr = [[NSArray alloc]initWithArray:array];
            }
            if (_dataArr.count > 0 ) {
                [_tableView reloadData];
            }        }
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [_tableView footerEndRefreshing];
        
    }];
}
#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_titleArr count];
    }else{
        return [_dataArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        static NSString *latestAskTitleIdentifier = @"latestAskTitleIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:latestAskTitleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:latestAskTitleIdentifier];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            view.backgroundColor = [UIColor colorWithRed:0.84 green:0.87 blue:0.87 alpha:1];
            [cell.contentView addSubview:view];
            
        }
        cell.imageView.image = [UIImage imageNamed:_titleImageArr[indexPath.row]] ;
        cell.textLabel.text = _titleArr [indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:0.33 green:0.63 blue:0.61 alpha:1];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *latestAskIdentifier = @"latestAskIdentifier" ;
        LatestAskCell *cell = [tableView dequeueReusableCellWithIdentifier:latestAskIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LatestAskCell"  owner:self options:nil] lastObject];
        }
        cell.dic = _dataArr[indexPath.row];
        cell.imageV.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ( section==0) {
        return nil;
    }else{
        return @"最新提问";
    }
    
}
#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[AskOnlineViewController alloc] init] animated:YES];
        }else{
            [self.navigationController pushViewController:[[PetHospitalViewController alloc ]init] animated:YES];
        }
    }else{
        NSDictionary *dic = _dataArr[indexPath.row];
        [self.navigationController pushViewController:[[MyAskDetailViewController alloc] initWithId:[dic objectForKey:@"postId"]] animated:YES];
        
    }
}
@end
