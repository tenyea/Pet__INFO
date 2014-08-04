//
//  PetHospitalViewController.m
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetHospitalViewController.h"
#import "HospitalCell.h"
#import "PetHospitalDetailViewController.h"
#import "HospitalModel.h"
@interface PetHospitalViewController ()
{
    NSArray *_dataArr;
    UITableView *_tableView;
}
@end

@implementation PetHospitalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![Network isConnectionAvailable ]) {
        self.bgStr = @"当前无网络,请稍后再试";
        return ;
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];


//    获取数据
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [self getDate:URL_getHospitalList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {

        int code = [[responseObject objectForKey:@"code"]intValue];
//        成功
        if (code == 0 ) {
            NSArray *array = [responseObject objectForKey:@"hospital"];
            NSMutableArray *mArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic  in array) {
                HospitalModel *model  = [[HospitalModel alloc]initWithDataDic:dic];
                [mArr addObject:model];
            }
            _dataArr = [NSArray arrayWithArray:mArr];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);

    }];
}
#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *hosptialIdentifier = @"hosptialIdentifier" ;
    HospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:hosptialIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HospitalCell"  owner:self options:nil] lastObject];
    }
    cell.model = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalModel *model = _dataArr[indexPath.row];
    [self.navigationController pushViewController:[[PetHospitalDetailViewController alloc]initWithHospitail:model] animated:YES];
}
@end
