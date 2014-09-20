//
//  StoryCommentsViewController.m
//  宠信
//
//  Created by tenyea on 14-8-13.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryCommentsViewController.h"
#import "StoryCommentsCell.h"

#import "MJRefresh.h"
@interface StoryCommentsViewController ()
{
    NSString *_petPhtotId;
    
    NSArray *_dateArr;
    UITableView *_tableView;
    UIButton *_bottomButton;
    UIView *_bgView;
    UIView *_bottomView;
    
    BOOL flag;//是否校验
}
@end

@implementation StoryCommentsViewController

-(id)initWithPetId:(NSString *)petPhotoId {
    self = [super init];
    if (self) {
        _petPhtotId = petPhotoId;
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
    self.title = @"回帖";
    _textView.delegate = self;
    
    //            防止table偏移
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:view];
    _bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight  -50  , ScreenWidth, 50)];
    [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomButton setTitle:@"写回帖" forState:UIControlStateNormal];
    _bottomButton.backgroundColor = [UIColor grayColor];
    [_bottomButton addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64-35, ScreenWidth, ScreenHeight -64 +35 -50 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
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
    
    
    [self getDate:URL_getDisList andParams:@{@"petPhotoId": _petPhtotId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code" ] intValue ] == 0) {
            _dateArr = [responseObject objectForKey:@"petPhotoDis"];
            if (_dateArr.count > 0) {
                [_tableView reloadData];
            }
        }else{
            _pn([[responseObject objectForKey:@"code"] intValue]);
            self.bgStr = Tenyea_str_load_error;
            
        }
        [_tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
        [_tableView headerEndRefreshing];
    }];

}
//下拉 加载
-(void)footerRereshing{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:_petPhtotId forKey:@"petPhotoId"];
    if (_dateArr.count > 0) {
        NSDictionary *dic = [_dateArr lastObject];
        NSString *str = [dic objectForKey:@"petPhotoDisId"];
        [params setObject:str forKey:@"lastId"];
    }
    [self getDate:URL_getDisList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code" ] intValue ] == 0) {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dateArr];

            NSArray *arr = [responseObject objectForKey:@"petPhotoDis"];
            if (arr.count > 0 ) {
                NSMutableArray *mArr = [[NSMutableArray alloc]init];

                for (int i = 0 ; i < arr.count ; i ++ ) {
                    NSDictionary *dic = arr[i];
                    [mArr addObject: dic];
                }
                [array  addObjectsFromArray:mArr];
                _dateArr = [[NSArray alloc]initWithArray:array];
            }
            
            if (_dateArr.count > 0) {
                [_tableView reloadData];
            }
        }else{
            _pn([[responseObject objectForKey:@"code"] intValue]);
            self.bgStr = Tenyea_str_load_error;
            
        }
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
        [_tableView footerEndRefreshing];
    }];
}
#pragma mark -
#pragma mark Action
-(void)commentsAction:(UIButton *)button {
    self.bottomViewTitle.text = @"写回帖";
    [self commentsAction];
}
/**
 *  评论事件
 */
-(void)commentsAction{
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
        _textView.returnKeyType = UIReturnKeyDone;
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
        [button1 addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button1];
    }
    _bottomView.hidden = NO;
    _bgView.hidden = NO;
    [_textView becomeFirstResponder];
}
//取消按钮和提交按钮
-(void)cancelButtonAction{
    _bottomView.hidden = YES;
    _bgView.hidden = YES;
    [_textView resignFirstResponder];
}
-(void)submitButtonAction{
    [self submitAction];
}
//取消手势
-(void)cancelAction:(UITapGestureRecognizer *)gesture{
    _bottomView.hidden = YES;
    _bgView.hidden = YES;
    [_textView resignFirstResponder];
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
    [params setObject:_petPhtotId forKey:@"petPhotoId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str] forKey:@"userId"];
    [params setObject:_textView.text forKey:@"text"];
    [self getDate:URL_AddDis andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code" ] intValue ] == 0) {
            [self showHudInBottom:@"回复成功"  autoHidden : YES];

        }else{
            _pn([[responseObject objectForKey:@"code"] intValue]);
            self.bgStr = Tenyea_str_load_error;
        }
        [self cancelButtonAction];
        [_tableView headerBeginRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];
}


#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (flag) {
        [self submitAction];
    }else{
        
    }
}

#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dateArr count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *storyCommentsIdentifier = @"storyCommentsIdentifier" ;
 
    StoryCommentsCell *cell = (StoryCommentsCell *)[tableView dequeueReusableCellWithIdentifier:storyCommentsIdentifier];
    if (cell == nil) {
        cell = [[StoryCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storyCommentsIdentifier];
    }
    cell.dic = _dateArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [StoryCommentsCell  getCommentHeight:[_dateArr[indexPath.row ] objectForKey:@"petPhotoDisText"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dateArr[indexPath.row];
    NSString *content = [dic objectForKey:@"petPhotoDisId"];
    NSString *userName = [dic objectForKey:@"petPhotoDisUserName"];
    self.bottomViewTitle.text = [NSString stringWithFormat:@"回复:%@",userName];
    [self commentsAction];
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
    flag = YES;
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
    flag = NO;
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
