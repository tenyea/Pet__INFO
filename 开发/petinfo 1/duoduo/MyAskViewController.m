//
//  MyAskViewController.m
//  宠信
//
//  Created by tenyea on 14-7-17.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskViewController.h"
#import "MyAskCell.h"
#import "InquiryModel.h"
#import "MyAskDetailViewController.h"
#import "MJRefresh.h"
@interface MyAskViewController ()
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@end

@implementation MyAskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的问诊";
    if (![Network isConnectionAvailable ]) {
        self.bgStr = @"当前无网络,请稍后再试";
        return ;
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.width, 0.01f)];
    [self.view addSubview:_tableView];

    NSDictionary *dic = @{@"userId": [[NSUserDefaults standardUserDefaults]stringForKey:UD_userID_Str] };
    [self getDate:URL_getInquiryList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        成功
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            NSArray *arr = [responseObject objectForKey:@"postList"];
            NSMutableArray *mArr = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < arr.count ; i ++ ) {
                NSDictionary *dic = arr[i];
                [mArr addObject: [[InquiryModel alloc]initWithDataDic:dic]];
            }
            _dataArr = [[NSArray alloc]initWithArray:mArr];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = [error localizedDescription];
    }];
    //    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    下拉
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    NSDictionary *dic = @{@"userId": [[NSUserDefaults standardUserDefaults]stringForKey:UD_userID_Str] };

    [self getDate:URL_getInquiryList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            if (_dataArr.count > 0 ) {
                _dataArr = [[NSArray alloc]init];
            }
            NSArray *arr = [responseObject objectForKey:@"postList"];
            NSMutableArray *mArr = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < arr.count ; i ++ ) {
                NSDictionary *dic = arr[i];
                [mArr addObject: [[InquiryModel alloc]initWithDataDic:dic]];
            }
            _dataArr = [[NSArray alloc]initWithArray:mArr];
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
    [params setObject:[[NSUserDefaults standardUserDefaults]stringForKey:UD_userID_Str] forKey:@"userId"];
    if (_dataArr.count > 0 ) {
        InquiryModel *model = [_dataArr lastObject];
        NSString *lastId = model.postId;
        [params  setObject:lastId forKey:@"lastId"];
    }
    [self getDate:URL_getInquiryList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
            
            NSArray *arr = [responseObject objectForKey:@"postList"];
            if (arr.count > 0) {
                NSMutableArray *mArr = [[NSMutableArray alloc]init];
                for (int i = 0 ; i < arr.count ; i ++ ) {
                    NSDictionary *dic = arr[i];
                    [mArr addObject: [[InquiryModel alloc]initWithDataDic:dic]];
                }
                [array  addObjectsFromArray:mArr];
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
    
    return [_dataArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *inquiryIdentifier = @"inquiryIdentifier" ;
    MyAskCell *cell = (MyAskCell *) [tableView dequeueReusableCellWithIdentifier : inquiryIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyAskCell" owner:self options:nil] lastObject];
    }
    cell.model = _dataArr [indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InquiryModel *model = _dataArr [indexPath.row];
    [self.navigationController pushViewController:[[MyAskDetailViewController alloc]initWithId:model.postId] animated:YES];
}

@end
