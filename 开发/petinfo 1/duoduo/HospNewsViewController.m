//
//  HospNewsViewController.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "HospNewsViewController.h"
#import "PetHosContentViewController.h"
#import "UIImageView+AFNetworking.h"
@interface HospNewsViewController ()

@end

@implementation HospNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dic = @{@"hosId": self.HosId  ,@"type":@"2"};
    [self getDate:URL_getHosInfoList andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        登陆成功
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            self.dataArr  = [responseObject objectForKey:@"hosInfo"];
            if ([self.dataArr count ]==0) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(50, 200, ScreenWidth - 50 *2, 20);
                label.text = @"暂时没有新动态";
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
    return [self.dataArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *hosNewsIdentifier = @"hosNewsIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier : hosNewsIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hosNewsIdentifier];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        imageView.tag = 1000;
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 240, 25)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.tag = 1001;
        [cell.contentView addSubview:label];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 240, 20)];
        textLabel.textColor = [UIColor grayColor];
        textLabel.tag = 1002;
        textLabel.font = FONT(12);
        [cell.contentView addSubview:textLabel];
        
    }
    
    UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 1000);
    UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 1001);
    UILabel *textLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 1002);
    [imageView setImageWithURL: [NSURL URLWithString:[self.dataArr[indexPath.row] objectForKey:@"hosInfoPic" ]]];
    label.text =[self.dataArr[indexPath.row] objectForKey:@"hosInfoTitle" ];
    textLabel.text = [self.dataArr[indexPath.row] objectForKey:@"hosInfoDes" ];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[PetHosContentViewController alloc]initWithUrl:URL_getHosInfo id:[self.dataArr[indexPath.row] objectForKey:@"hosInfoListId"]] animated:YES];

}
@end
