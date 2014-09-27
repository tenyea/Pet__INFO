//
//  DailyFeedingViewController.m
//  宠信
//
//  Created by tenyea on 14-8-14.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "DailyFeedingViewController.h"

@interface DailyFeedingViewController ()
{
    NSString *_KnowledgeListId;
    UIView *_topView;
    UITextView *_bottomTextView;
    NSArray *_contentArr;
    UIScrollView *_bottomScrollview;
    
    UIView *_slider;
}
@end

@implementation DailyFeedingViewController

-(id)initWithKnowledgeListId:(NSString *)KnowledgeListId{
    if (self = [super init]) {
        _KnowledgeListId = KnowledgeListId;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *nameArr = @[@"病因",@"临床",@"检查",@"诊断",@"治疗",@"预防"];
    [self getDate:URL_getFeed andParams:@{@"knowledgeListId": _KnowledgeListId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 0 ){
            
            NSDictionary *dic = [responseObject objectForKey:@"feed"];
            
            if (dic == [NSNull null]) {
                self.bgStr = Tenyea_str_load_error;
                return ;
            }
            NSString *feedCause = [dic objectForKey:@"feedCause"];
            NSString *feedClinic = [dic objectForKey:@"feedClinic"];
            NSString *feedExa = [dic objectForKey:@"feedExa"];
            NSString *feedDiag = [dic objectForKey:@"feedDiag"];
            NSString *feedCure = [dic objectForKey:@"feedCure"];
            NSString *feedProg = [dic objectForKey:@"feedProg"];
            _contentArr = @[feedCause,feedClinic,feedExa,feedDiag,feedCure,feedProg];
            
            _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
            [self.view addSubview: _topView];
            
            for (int i = 0 ; i < nameArr.count; i ++ ) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0 + i * ScreenWidth/nameArr.count, 0, ScreenWidth/nameArr.count, 40)];
                [button setTitle:nameArr[i] forState:UIControlStateNormal];
                button.tag = 100 + i;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button addTarget: self  action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
                [_topView addSubview:button];
            }
            
            _slider = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth/nameArr.count, 5)];
            _slider.backgroundColor = [UIColor colorWithRed:0.19 green:0.79 blue:0.61 alpha:1];
            [_topView addSubview:_slider];
            
            _bottomScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 + 50, ScreenWidth, ScreenHeight- 50-64)];
            _bottomScrollview.contentSize = CGSizeMake(nameArr.count*ScreenWidth, ScreenHeight- 50-64);
            _bottomScrollview.pagingEnabled = YES;
            for (int i = 0 ; i < _contentArr.count ; i ++   ) {
                UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake( ScreenWidth*i, 0, ScreenWidth, ScreenHeight - 50 -64)];
                [_bottomScrollview addSubview:bottomView];
                _bottomTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50 -64)];
                [bottomView addSubview:_bottomTextView];
                _bottomTextView.text = _contentArr[i];
                _bottomTextView.delegate = self;
                bottomView.backgroundColor = [UIColor redColor];

            }
            _bottomScrollview.showsHorizontalScrollIndicator = NO;
            _bottomScrollview.showsVerticalScrollIndicator = NO;
            [self.view addSubview:_bottomScrollview];
            _bottomScrollview.delegate = self;
            
            
        }else{
            self.bgStr = Tenyea_str_load_error;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];
}
-(void)selectAction:(UIButton *)button {
    int selectId = button.tag - 100;
    _bottomScrollview.contentOffset = CGPointMake(selectId * ScreenWidth, 0);
    [UIView animateWithDuration:.2 animations:^{
        _slider.left = selectId*ScreenWidth/_contentArr.count;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int selectId = _bottomScrollview.contentOffset.x/ScreenWidth;
    [UIView animateWithDuration:.2 animations:^{
        _slider.left = selectId*ScreenWidth/_contentArr.count;
    }];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}
@end
