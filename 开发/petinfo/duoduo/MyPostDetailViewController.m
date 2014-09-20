//
//  MyPostDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-7-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostDetailViewController.h"
#import "MyPostTopCell.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import "MJRefresh.h"
@interface MyPostDetailViewController ()
{
    NSString *_postId;
    UITableView *_tableView;
    NSArray *_dataArr;
    NSDictionary *_topDic;
    UILabel *_animateLabel;
    BOOL isGood ;//是否点赞 0:未点赞 1 点赞

    UIView *_bottomView;
    UIView *_bgView;
    NSString *_petPhotoDisId;//回复楼层id
}
@end

@implementation MyPostDetailViewController
-(id)initWithId:(NSString *)postId{
    self = [super init];
    if (self) {
        _postId = postId;
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

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64  , ScreenWidth, ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.width, 0.01f)];
    NSArray *arr = @[@"评论",@"喜欢",@"分享"];//
    NSArray *arrImage = @[@"story_comment.png",@"story_like.png",@"story_share.png"];
    for (int i = 0 ; i < arr.count;  i ++ ) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + i *100, ScreenHeight - 40, 70, 30)];
        button.tag = 100 + i ;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.backgroundColor = [UIColor colorWithRed:0.89 green:0.4 blue:0.17 alpha:1];
        button.titleLabel.font = FONT(15);
        [button setImage:[UIImage imageNamed:arrImage[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    //    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    下拉
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [_tableView headerBeginRefreshing];
}
#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str];
    [self getDate:URL_getPostContent andParams:@{@"petPhotoId": _postId,@"userId":userId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _topDic = [responseObject objectForKey: @"petPhotoPost"] ;
            
            //            回复内容
            _dataArr = [responseObject objectForKey:@"petPhotoDis"];
            [_tableView reloadData];
            
            isGood = [[responseObject objectForKey:@"isGood"] boolValue];
            //            未点赞
            if ( !isGood ) {
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateHighlighted];
                [button setImage:[UIImage imageNamed:@"story_like.png"] forState:UIControlStateNormal];
            }
            //            已点赞
            else{
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setTitle:@"已喜欢" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateNormal];
                
            }
        }else{
            self.bgStr = Tenyea_str_load_error;
        }
        [_tableView headerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = [error localizedDescription];
        _po([error localizedDescription]);
        [_tableView headerEndRefreshing];

    }];

}
//下拉 加载
-(void)footerRereshing{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (_dataArr.count > 0) {
        NSString *petPhotoId = [[_dataArr lastObject] objectForKey:@"petPhotoDisId"];
        [params setObject:petPhotoId forKey:@"lastId"];
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str];
    [params setObject:userId forKey:@"userId"];
    [params setObject:_postId forKey:@"petPhotoId"];
    [self getDate:URL_getPostContent andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            _topDic = [responseObject objectForKey: @"petPhotoPost"] ;
            
            
            isGood = [[responseObject objectForKey:@"isGood"] boolValue];
            //            未点赞
            if ( !isGood ) {
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateHighlighted];
                [button setImage:[UIImage imageNamed:@"story_like.png"] forState:UIControlStateNormal];
            }
            //            已点赞
            else{
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setTitle:@"已喜欢" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateNormal];
                
            }
            //            回复内容
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
            
            NSArray *arr = [responseObject objectForKey:@"petPhotoDis"];
            if (arr.count > 0) {
                NSMutableArray *mArr = [[NSMutableArray alloc]init];
                for (int i = 0 ; i < arr.count ; i ++ ) {
                    NSDictionary *dic = arr[i];
                    [mArr addObject: dic];
                }
                [array  addObjectsFromArray:mArr];
                _dataArr = [[NSArray alloc]initWithArray:array];
            }
            if (_dataArr.count > 0 ) {
                [_tableView reloadData];
            }
        }else {
            self.bgStr = Tenyea_str_load_error;
        }
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = Tenyea_str_load_error;
        _po([error localizedDescription]);
        [_tableView footerEndRefreshing];
        
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
//            cell = [[MyPostTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPostTopIdentifier];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyPostTopCell" owner:self options:nil]lastObject];
        }
        cell.dic = _topDic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *myPostContentIdentifier = @"myPostContentIdentifier";
        MyPostDetailCell *cell = (MyPostDetailCell *)[tableView dequeueReusableCellWithIdentifier:myPostContentIdentifier];
        if (cell == nil) {
//            cell =  [[MyPostDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPostContentIdentifier];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyPostDetailCell" owner:self options:nil]lastObject];
            cell.eventDelegate = self;
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



#pragma mark -
#pragma mark reActionDelegate
-(void)reAction:(NSString *)petPhotoDisId  userName:(NSString *)userName{
    DLOG(@"id为%@的楼层被选中",petPhotoDisId);
    [self commentsAction:petPhotoDisId userName:userName];
}
#pragma mark -
#pragma mark Action
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
-(void)selectAction:(UIButton *)button{
    switch (button.tag) {
        case 100://评论
            [self commentsAction:@"" userName:@""];

            break;
            case 101://喜欢
            [self likeAction];

            break;
            case 102://评论
            [self shareAction];

            break;
        default:
            break;
    }
}

/**
 *  提交评论事件
 */
-(void)submitAction{

    if ([_textView.text isEqualToString:@""]) {
        [self showHudInBottom:@"说点什么吧"  autoHidden : YES];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:_postId forKey:@"petPhotoId"];
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
    if ([userName isEqualToString:@""]) {
        self.bottomViewTitle.text = @"写回帖";
        _petPhotoDisId = @"0";
    }else{
        self.bottomViewTitle.text = [NSString stringWithFormat:@"回复:%@",userName];
        _petPhotoDisId = petPhotoDisId;
    }
    _bottomView.hidden = NO;
    _bgView.hidden = NO;
    [_textView becomeFirstResponder];
}


/**
 *  点赞的事件
 */
- (void)likeAction {
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    
    // 读取
    NSString *userId = [myUserDefaults objectForKey:UD_userID_Str];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_postId forKey:@"petPhotoId"];
    [dic setValue:userId forKey:@"userId"];
    
    
    [self getDate:URL_Like andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        int a = [code intValue];
        if(a==0)
        {
            isGood = !isGood;
            if ( !isGood) {
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setTitle:@"喜欢" forState:UIControlStateNormal];
                
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateHighlighted];
                [self labelAnimate:@"-1"];
                [button setImage:[UIImage imageNamed:@"story_nolike.png"] forState:UIControlStateNormal];
            }else{
                UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);
                [button setTitle:@"已喜欢" forState:UIControlStateNormal];
                [self labelAnimate:@"+1"];
                [button setImage:[UIImage imageNamed:@"story_select_like.png"] forState:UIControlStateNormal];
                
            }
        }else
        {
            // 去登陆  缺少userID
            [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.bgStr = Tenyea_str_load_error;
    }];
    
    
}
/**
 *  分享事件
 */
- (void)shareAction {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
/**
 *  点赞的动画，label消失的动画
 *
 *  @param text 消失的文字（-1/+1）
 */
-(void)labelAnimate :(NSString *)text{
    UIButton *button = (UIButton *)VIEWWITHTAG(self.view, 101);

    if (!_animateLabel) {
        _animateLabel =[[UILabel alloc]init];
        _animateLabel.font = [UIFont boldSystemFontOfSize:15];
        _animateLabel.height = 13;
        _animateLabel.width = 15;
        _animateLabel.right = button.right - 20;
        [self.view addSubview:_animateLabel];
    }
    if ([text isEqualToString:@"-1"]) {
        _animateLabel.textColor = [UIColor grayColor];
    }else{
        _animateLabel.textColor = [UIColor redColor];
    }
    _animateLabel.top = button.top;
    _animateLabel.alpha = 1;
    _animateLabel.text = text;
    [UIView animateWithDuration:1.2 animations:^{
        _animateLabel.top = button.top - 23;
        _animateLabel.alpha = 0;
    } ];
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
        _bottomViewTitle.text = @"写回帖";
        _bottomViewTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomViewTitle;
}
@end
