//
//  MyAskDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyAskDetailViewController.h"
#import "MyAskDetailCell.h"
#import "MyAskDetailTopCell.h"
#import "MyAskDocView.h"
#import "UIImageView+AFNetworking.h"
@interface MyAskDetailViewController ()
{
    NSString *_askId;
    UITableView *_tableView;
    NSArray *_dataArr;
    NSDictionary *_topDic;
}
@end

@implementation MyAskDetailViewController

-(id)initWithId:(NSString *)askId{
    self = [super init];
    if (self) {
        _askId = askId;
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

    [self getDate:URL_getInquiryContent andParams:@{@"postId": _askId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _topDic = [responseObject objectForKey: @"post"] ;
            
//            回复内容
            _dataArr = [responseObject objectForKey:@"reply"];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = [error localizedDescription];
        _po([error localizedDescription]);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *myAskDetailTopIdentifier = @"myAskDetailTopIdentifier";
        MyAskDetailTopCell *cell = (MyAskDetailTopCell *)[tableView dequeueReusableCellWithIdentifier:myAskDetailTopIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyAskDetailTopCell" owner:self options:nil] lastObject];
        }
        cell.dic = _topDic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *myAskDetailContentIdentifier = @"myAskDetailContentIdentifier";
        MyAskDetailCell *cell = (MyAskDetailCell *)[tableView dequeueReusableCellWithIdentifier:myAskDetailContentIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyAskDetailCell" owner:self options:nil] lastObject];
        }
        int index = indexPath.section - 1;
        NSDictionary *dic = _dataArr[index];
        cell.content = [dic objectForKey:@"replyText"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count] +1;
}
#pragma mark - 
#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_dataArr count] == 0 ) {
        return nil;
    }
    
    if (section > ([_dataArr count]- 1)) {
        return nil;
    }
    MyAskDocView *view = [[[NSBundle mainBundle]loadNibNamed:@"MyAskDocView" owner:self options:nil] lastObject];
    view.dic = _dataArr [section];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyAskDetailTopCell getCellHeight: _topDic];
    }
    NSString *str = nil;
    
    int index = indexPath.section - 1;
    NSDictionary *dic = _dataArr[index];
    str = [dic objectForKey:@"replyText"];
    return  [MyAskDetailCell getCellHeight:str];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_dataArr count] == 0 ) {
        return 0;
    }
    return 65;
}
@end
