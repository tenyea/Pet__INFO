//
//  MyReplyViewController.m
//  宠信
//
//  Created by tenyea on 14-9-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyReplyViewController.h"
#import "MJRefresh.h"
#import "MyReplyCell.h"
#import "UserInfoDetailViewController.h"
@interface MyReplyViewController ()

{
    UITableView *_tableView;
    NSArray *_myReplyArr;
    NSArray *_replyToMeArr;
    UIButton *rightButton;
    UIButton *leftButton;
    
    NSDictionary *_selectDic;
    
    UIView *_bottomView;
    UIView *_bgView;
    NSString *_petPhotoDisId;//回复楼层id

}
@end

@implementation MyReplyViewController

-(id)init{
    self = [super init];
    if (self) {
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHiden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.width, 0.01f)];
    [self.view addSubview:_tableView];

    
    //    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    下拉
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self _initNavTopView];
    
    [self getDatebyNewwor:NO];
}
/**
 *  nav上的视图
 */
-(void)_initNavTopView{

    leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 60, 40);
    [leftButton addTarget:self action:@selector(myReply) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"我的回复" forState:UIControlStateNormal];
    leftButton.titleLabel.font = FONT(14);
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];

    rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(80, 0, 60, 40);
    [rightButton addTarget:self action:@selector(replyToMe) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"回复我的" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(14);
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    leftButton.selected = YES;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 40)];
    [topView addSubview:rightButton];
    [topView addSubview:leftButton];
    self.navigationItem.titleView = topView;
}
#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    [self getDatebyNewwor:YES];
}
-(void)footerRereshing{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:UD_userID_Str];
    NSString *type = @"1";
    NSDictionary *lastDic ;
    //    我的回复
    if (leftButton.selected) {
        type = @"1";
        if (_myReplyArr.count > 0 ) {
            lastDic = [_myReplyArr lastObject];

        }else{
            return;
        }
    }
    //    回复我的
    else{
        type = @"0";
        if (_replyToMeArr.count > 0 ) {
            lastDic = [_replyToMeArr lastObject];
        }else{
            return ;
        }
    }
    NSString *lastId = [lastDic objectForKey:@"petPhotoDisId"];
    [self getDate:URL_Reply andParams:@{@"type":type,@"userId":userId,@"lastId":lastId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            if (leftButton.selected) {
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_myReplyArr];
                NSArray *arr = [responseObject objectForKey:@"huiFuWoDeList"];
                if (arr.count > 0 ) {
                    NSMutableArray *mArr = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i < arr.count ; i ++ ) {
                        NSDictionary *dic = arr[i];
                        [mArr addObject: dic];
                    }
                    [array  addObjectsFromArray:mArr];
                    _myReplyArr = [[NSArray alloc]initWithArray:array];
                }
                
                if (_myReplyArr.count > 0) {
                    [_tableView reloadData];
                }
            }else{
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_replyToMeArr];
                NSArray *arr = [responseObject objectForKey:@"huiFuWoDeList"];
                if (arr.count > 0 ) {
                    NSMutableArray *mArr = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i < arr.count ; i ++ ) {
                        NSDictionary *dic = arr[i];
                        [mArr addObject: dic];
                    }
                    [array  addObjectsFromArray:mArr];
                    _replyToMeArr = [[NSArray alloc]initWithArray:array];
                }
                
                if (_replyToMeArr.count > 0) {
                    [_tableView reloadData];
                }
            }
            
        }else {
            _pn([[responseObject objectForKey:@"code"] intValue]);
            self.bgStr = Tenyea_str_load_error;
        }
        
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = [error localizedDescription];
        _po([error localizedDescription]);
        [_tableView footerEndRefreshing];
    }];
    
}

-(void)getDatebyNewwor:(BOOL)isNeedEndRefreshing {
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:UD_userID_Str];
    NSString *type = @"1";
//    我的回复
    if (leftButton.selected) {
        type = @"1";
    }
//    回复我的
    else{
        type = @"0";
    }
    //    我的回复
    [self getDate:URL_Reply andParams:@{@"type":type,@"userId":userId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            if (leftButton.selected) {
                _myReplyArr = [responseObject objectForKey:@"huiFuWoDeList"];
                if (_myReplyArr.count > 0 ) {
                    [_tableView reloadData];
                }else{
                }
            }else{
                _replyToMeArr = [responseObject objectForKey:@"huiFuWoDeList"];
                if (_replyToMeArr.count > 0 ) {
                    [_tableView reloadData];
                }else{
                }

            }
            
        }else {
            self.bgStr = Tenyea_str_load_error;
        }
        if (isNeedEndRefreshing) {
            [_tableView headerEndRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = [error localizedDescription];
        _po([error localizedDescription]);
        if (isNeedEndRefreshing) {
            [_tableView headerEndRefreshing];
        }
    }];
}

#pragma mark -
#pragma mark Action

/**
 *  提交评论事件
 */
-(void)submitAction{
    
    if ([_textView.text isEqualToString:@""]) {
        [self showHudInBottom:@"说点什么吧"  autoHidden : YES];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[_selectDic objectForKey:@"petPhotoId"] forKey:@"petPhotoId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str] forKey:@"userId"];
    NSString *text = _textView.text;
    NSArray *arr = [text componentsSeparatedByString:@"\n"];
    [params setObject:[arr componentsJoinedByString:@""] forKey:@"text"];
    if ([_petPhotoDisId intValue]!=0) {
        [params setObject:_petPhotoDisId forKey:@"petPhotoDisId"];
    }
    [self getDate:URL_AddDis andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code" ] intValue ] == 0) {
            [self showHudInBottom:@"回复成功"  autoHidden : YES];
            
        }else{
            _pn([[responseObject objectForKey:@"code"] intValue]);
            self.bgStr = Tenyea_str_load_error;
        }
        [self cancelButtonAction];
        [self headerRereshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];
}
//取消按钮和提交按钮
-(void)cancelButtonAction{
    _bottomView.hidden = YES;
    _bgView.hidden = YES;
    [_textView resignFirstResponder];
}

//取消手势
-(void)cancelAction:(UITapGestureRecognizer *)gesture{
    _bottomView.hidden = YES;
    _bgView.hidden = YES;
    [_textView resignFirstResponder];
}
/**
 *  回复我的
 */
-(void)replyToMe{
    rightButton.selected = YES;
    leftButton.selected = NO;
    [self getDatebyNewwor:NO];
}
/**
 *  我回复的
 */
-(void)myReply{
    rightButton.selected = NO;
    leftButton.selected = YES;
    [self getDatebyNewwor:NO];
}
#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (rightButton.selected) {
        return [_replyToMeArr count];
    }else{
        return [_myReplyArr count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myReplyIdentifier = @"myReplyIdentifier" ;
    MyReplyCell *cell = (MyReplyCell *)[tableView dequeueReusableCellWithIdentifier:myReplyIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyReplyCell" owner:self options:nil] lastObject];
    }
    if (leftButton.selected) {
        cell.MyReply = YES;
        cell.dic = _myReplyArr[indexPath.row];
    }else {
        cell.MyReply = NO;
        cell.dic = _replyToMeArr[indexPath.row];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (leftButton.selected) {
        _selectDic = _myReplyArr[indexPath.row];

        NSString *myReplyStr;
        if ([[_selectDic objectForKey:@"huifuUserName"] isEqualToString:@""]) {
            myReplyStr  = [NSString stringWithFormat:@"查看%@的资料",[_selectDic objectForKey:@"petPhotoUserName"]];
        }else{
            myReplyStr  = [NSString stringWithFormat:@"查看%@的资料",[_selectDic objectForKey:@"huifuUserName"]];
        }
        UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:myReplyStr, nil ];
        [as showInView:self.navigationController.view];
    }else{
        _selectDic = _replyToMeArr[indexPath.row];
        NSString *myReplyStr = [NSString stringWithFormat:@"查看%@的资料",[_selectDic objectForKey:@"petPhotoDisUserName"]];
        UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:myReplyStr,@"回复", nil ];
        [as showInView:self.navigationController.view];
    }
    
}
#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (rightButton.selected) {
        
        switch (buttonIndex) {
            case 0://查看资料
                [self.navigationController pushViewController:[[UserInfoDetailViewController alloc] initWithUserId: [_selectDic objectForKey:@"petPhotoDisUserId"]] animated:YES];
                break;
            case 1://回复
                [self commentsAction:[_selectDic objectForKey:@"petPhotoDisId"] userName:[_selectDic objectForKey:@"petPhotoDisUserName"]];
                
                break;
                
            default:
                break;
        }
    }else{
        if (buttonIndex == 0 ) {//查看资料
            if ([[_selectDic objectForKey:@"huifuUserName"] isEqualToString:@""]) {
                [self.navigationController pushViewController:[[UserInfoDetailViewController alloc] initWithUserId: [_selectDic objectForKey:@"petPhotoUserId"]] animated:YES];
            }else{
                [self.navigationController pushViewController:[[UserInfoDetailViewController alloc] initWithUserId: [_selectDic objectForKey:@"huifuUserId"]] animated:YES];
            }
            
        }
    }
}


/**
 *  评论
 *
 *  @param petPhotoDisId 评论萌照id   （空时为回复照片。不为空是为回复某一楼）
 *  @param userName 回复的用户名
 */
-(void)commentsAction:(NSString *)petPhotoDisId userName:(NSString *)userName{
    //初始化背景视图
    if (!_bgView) {
        _bgView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [UIColor grayColor];
        _bgView.alpha = .7;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction:)];
        gesture.numberOfTouchesRequired = 1;
        [_bgView addGestureRecognizer: gesture];
        [self.view addSubview:_bgView];
        _bgView.hidden = YES;
    }
    //初始化底部视图
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 140)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(19, 49, ScreenWidth - 40 + 2, 140 - 50 - 10 +2)];
        view.backgroundColor = [UIColor grayColor];
        [_bottomView addSubview:view];
        _textView = [[UITextView alloc]initWithFrame: CGRectMake(20, 50, ScreenWidth - 40, 140 - 50 - 10)];
        _textView.delegate = self;
        [_bottomView addSubview:_textView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, ScreenWidth - 120, 30)];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.text = @"写回帖";
        label.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:self.bottomViewTitle];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 40, 30)];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 20 - 40, 10, 40, 30)];
        [button1 setTitle:@"提交" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button1];
    }
    self.bottomViewTitle.text = [NSString stringWithFormat:@"回复:%@",userName];
    _petPhotoDisId = petPhotoDisId;
    _bottomView.hidden = NO;
    _bgView.hidden = NO;
    [_textView becomeFirstResponder];
}


#pragma mark -
#pragma mark Notification
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (![_textView.text isEqualToString:@""]) {
        _textView.text = @"";
    }
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyboardHeight = keyboardRect.origin.y;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    _bottomView.bottom = keyboardHeight;
    [UIView commitAnimations];
}
-(void)keyboardWillHiden:(NSNotification *)aNotification
{
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyboardHeight = keyboardRect.origin.y;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _bottomView.bottom = keyboardHeight;
    [UIView commitAnimations];
}
#pragma -
#pragma mark @property
-(UILabel *)bottomViewTitle{
    if (!_bottomViewTitle) {
        _bottomViewTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, ScreenWidth - 120, 30)];
        _bottomViewTitle.font = [UIFont boldSystemFontOfSize:20];
        _bottomViewTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomViewTitle;
}
@end
