//
//  EnvironmentViewController.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "EnvironmentViewController.h"
#import "EnvironmentCell.h"
@interface EnvironmentViewController ()

@end

@implementation EnvironmentViewController

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
    //    hosId	Int	是	医院id
    //    type	Int	是	医院信息分类 0:医院动态,1:医院环境,2:医疗设备
    //    lastId	Int	否	加载id
    NSDictionary *dic = @{@"hosId": self.HosId  ,@"type":@"1"};
    [self getDate:URL_getHosInfoList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        登陆成功
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            self.dataArr  = [responseObject objectForKey:@"hosInfo"];
            if ([self.dataArr count ]==0) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(50, 200, ScreenWidth - 50 *2, 20);
                label.text = @"暂时没有上传环境信息";
                label.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:label];
                return ;
            }
            //            防止table便宜
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.view addSubview:view];
            
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:self.tableView];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
        return ;
        
    }];

}

#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataArr count]%2 == 0) {
        return [self.dataArr count]/2;
    }else{
        return [self.dataArr count]/2 + 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *equipIdentifier = @"equipIdentifier" ;
    EnvironmentCell *cell = (EnvironmentCell *)[tableView dequeueReusableCellWithIdentifier : equipIdentifier];
    
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnvironmentCell" owner:self options:nil] lastObject];
    }
    NSDictionary *leftDic = self.dataArr[ 2 *indexPath.row];
    NSDictionary *rightDic;
    if (indexPath.row *2 + 1 < self.dataArr.count) {
        rightDic = self.dataArr [2 *indexPath.row + 1];
    }
    if (rightDic) {
        cell.arr = @[leftDic,rightDic];
    }else{
        cell.arr = @[leftDic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

@end
