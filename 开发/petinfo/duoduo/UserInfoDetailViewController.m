//
//  UserInfoDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import "MJRefresh.h"
#import "UserPetInfoCell.h"
#import "UIImageView+AFNetworking.h"
#import "UserPostCell.h"
@interface UserInfoDetailViewController ()
{
    UITableView *_tableView;
    NSString *_userId;
    NSArray *_petArr;
    NSArray *_dataArr;//帖子数据
    NSDictionary *_userInfoDIC;
    
    BOOL showAllPet;
    BOOL showAllPost;
    NSInteger showIndex;
    NSArray *labelArr ;
}
@end

@implementation UserInfoDetailViewController

-(id)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    labelArr = @[@"他的宠物",@"他的帖子"];
    showAllPet = YES;
    UIScrollView *bgScView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview: bgScView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64-35  , ScreenWidth, ScreenHeight - 64 +35) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.sectionFooterHeight = 0;
    showIndex =  -1;
//    //    上拉
//    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//    //    下拉
//    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self getData:NO];
}
#pragma mark -
#pragma mark MJRefresh
-(void)headerRereshing{
    [self getData:YES];
}
-(void)getData:(BOOL)needEndRefreshing{
    [self getDate:URL_getUserInfo andParams:@{@"userId": _userId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _userInfoDIC = [responseObject objectForKey:@"userInfo"];
            _dataArr = [responseObject objectForKey:@"petPhoto"];
            _petArr = [responseObject objectForKey:@"pet"];
            if(_petArr.count > 2){
                showAllPet = NO;
            }
            [_tableView reloadData];
            
        }else {
            self.bgStr = Tenyea_str_load_error;
        }
        if (needEndRefreshing) {
            [_tableView headerEndRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = [error localizedDescription];
        _po([error localizedDescription]);
        if (needEndRefreshing) {
            [_tableView headerEndRefreshing];

        }
    }];
}
-(void)footerRereshing{
    
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 1;
    }else if(section == 1){
        if (showAllPet) {
            return [_petArr count];

        }else{
            return 2;
        }
    }else{
        return [_dataArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        static NSString *userInfoIdentity = @"userInfoIdintity";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoIdentity];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoIdentity];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 55, 55)];
            imageView.tag = 100;
            [cell.contentView addSubview:imageView];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 200, 15)];
            titleLabel.textColor = [UIColor colorWithRed:0.77 green:0.45 blue:0.12 alpha:1];
            titleLabel.font = FONT(15);
            titleLabel.tag = 101;
            [cell.contentView addSubview:titleLabel];
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(220, 10, 95, 30);
            [button setTitle:@"+  加好友" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:0.81 green:0.18 blue:0.09 alpha:1];
            [button addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = FONT(12);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            [cell.contentView addSubview:button];
            
        }
        UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
        [imageView setImageWithURL:[NSURL URLWithString:[_userInfoDIC objectForKey:@"userHeadMin"]]];
        UILabel *titleLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
        titleLabel.text = [_userInfoDIC objectForKey:@"userNickname"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(indexPath.section == 1){
        static NSString *userPetInfoIdintity = @"userPetInfoIdentity";
        UserPetInfoCell *cell = (UserPetInfoCell *)[tableView dequeueReusableCellWithIdentifier:userPetInfoIdintity];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserPetInfoCell" owner:self options:nil] lastObject];
        }
        if (_petArr.count > 0 ) {
            if (showAllPet) {
                cell.dic = _petArr[indexPath.row];
            }else{
                if (indexPath.row == 0 ) {
                    cell.dic = _petArr[0];
                }else{
                    cell.dic = [_petArr lastObject];
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *postInfoIdentity = @"postInfoIdentity";
        UserPostCell *cell = (UserPostCell*)[tableView dequeueReusableCellWithIdentifier:postInfoIdentity];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserPostCell" owner:self options:nil] lastObject];

        }
        if (_dataArr.count > 0 ) {
            cell.dic = _dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  用户发的帖子
     */
    if (indexPath.section == 2) {
        /**
         *  选中的是不同的,放下table
         */
        if(showIndex != indexPath.row){
            /**
             *  如果不是-1.则说明已经有选中的，则隐藏其图片
             */
            if(showIndex!=-1){
                NSIndexPath *index = [NSIndexPath indexPathForRow:showIndex inSection:2];
                UserPostCell *cell = (UserPostCell *)[tableView cellForRowAtIndexPath:index];
                [cell hiddenImage];
            }
            /**
             *  放下,显示图片
             */
            showIndex = indexPath.row;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            UserPostCell *newcell = (UserPostCell *)[tableView cellForRowAtIndexPath:indexPath];
            [newcell showImage];
        }
        /**
         *  选中的是相同的,收起table
         */
        else{
            showIndex = -1;
            UserPostCell *newcell = (UserPostCell *)[tableView cellForRowAtIndexPath:indexPath];
            [newcell.cusImageView setHidden:YES];
            [newcell hiddenImage];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 60;
    }else if(indexPath.section == 1){
        return 80;
    }else{
        if (indexPath.row == showIndex) {
            return 170;
        }
        return 30;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return 0;
    }else{
        return 42;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth, 40)];
    view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(190, 5, 130, 30)];
    [button setImage:[UIImage imageNamed:@"user_button.png"] forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    if (section == 1) {
        UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -2, ScreenWidth, 5)];
        bottomView.image = [UIImage imageNamed:@"myload_topbg.png"];
        [view addSubview:bottomView];
    }
    
    
//    左侧图标
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"user_info_button_logo.png"];
    [button addSubview:imageView];
//    标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 50, 20)];
    label.text = labelArr[section - 1];
    label.textColor = [UIColor colorWithRed:0.6 green:0.47 blue:0.93 alpha:1];
    label.font = FONT(12);
    [button addSubview:label];
//    旋转图片
    UIImageView *RrotationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 7, 15, 15)];
    if (section == 1) {
        if (!showAllPet) {
            RrotationImageView.image = [UIImage imageNamed:@"user_data_down.png"];
        }else{
            RrotationImageView.image = [UIImage imageNamed:@"user_data_up.png"];
            if (_petArr.count >2) {
                button.enabled = YES;
            }else{
                button.enabled = NO;
            }
        }
    }else{
        RrotationImageView.image = [UIImage imageNamed:@"user_data_down.png"];

    }
    
    RrotationImageView.tag = 1000 + section;
    [button addSubview:RrotationImageView];
    

    return view;
}
#pragma mark -
#pragma mark Action
-(void)showAction:(UIButton *)button{
    if (button.tag == 1) {
        
        showAllPet = !showAllPet;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}
/**
 *  加好友
 */
-(void)addUser{
    
}
@end
