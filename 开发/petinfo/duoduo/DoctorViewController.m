//
//  DoctorViewController.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "DoctorViewController.h"
#import "UIImageView+WebCache.h"
#import "DoctorCell.h"
#import "DoctorModel.h"
@interface DoctorViewController ()
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@end

@implementation DoctorViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dic = @{@"hosId": self.HosId  };
    [self getDate:URL_getDoctorList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        登陆成功
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            NSArray *arr  = [responseObject objectForKey:@"docList"];
            if ([arr count ]==0) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(50, 200, ScreenWidth - 50 *2, 20);
                label.text = @"暂时没有添加医生信息";
                label.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:label];
                return ;
            }
            NSMutableArray *mArr = [[NSMutableArray alloc]init];
            for (int i = 0 ; i < arr.count; i ++ ) {
                DoctorModel *model =  [[DoctorModel alloc]initWithDataDic: arr[i]];
                [mArr addObject:model];
            }
            self.dataArr = [NSArray arrayWithArray:mArr];
            //            防止table便宜
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.view addSubview:view];
            
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.view addSubview:self.tableView];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(50, 200, ScreenWidth - 50 *2, 20);
        label.text = @"出错了。。请稍后再试";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        return ;
        
    }];
}
#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *hosNewsIdentifier = @"hosNewsIdentifier" ;
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier : hosNewsIdentifier];
    
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DoctorCell" owner:self options:nil] lastObject];
    }
    cell.model = self.dataArr [indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}






@end
