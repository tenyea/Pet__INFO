//
//  MyPostDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostDetailViewController.h"
#import "MyPostTopCell.h"
#import "MyPostDetailCell.h"
@interface MyPostDetailViewController ()
{
    NSString *_postId;
    UITableView *_tableView;
    NSArray *_dataArr;
    NSDictionary *_topDic;
}
@end

@implementation MyPostDetailViewController
-(id)initWithId:(NSString *)postId{
    self = [super init];
    if (self) {
        _postId = postId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *bgScView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: bgScView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 - 35 , ScreenWidth, ScreenHeight - 64 + 35) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    
    
    [self getDate:URL_getPostContent andParams:@{@"petPhotoId": _postId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _topDic = [responseObject objectForKey: @"petPhotoPost"] ;
            
            //            回复内容
            _dataArr = [responseObject objectForKey:@"petPhotoDis"];
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
    return  ( [_dataArr count] + 1 );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *myPostTopIdentifier = @"myPostTopIdentifier";
        MyPostTopCell *cell = (MyPostTopCell *)[tableView dequeueReusableCellWithIdentifier:myPostTopIdentifier];
        if (cell == nil) {
            cell = [[MyPostTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPostTopIdentifier];
        }
        cell.dic = _topDic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *myPostContentIdentifier = @"myPostContentIdentifier";
        MyPostDetailCell *cell = (MyPostDetailCell *)[tableView dequeueReusableCellWithIdentifier:myPostContentIdentifier];
        if (cell == nil) {
            cell =  [[MyPostDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPostContentIdentifier];
        }
        int index = indexPath.row - 1;
        NSDictionary *dic = _dataArr[index];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [MyPostTopCell getCellHeight: _topDic];
    }else{
        return [MyPostDetailCell getCellHeight: _dataArr[indexPath.row - 1]];
    }
    
}



@end
