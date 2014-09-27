//
//  StoryContentViewController.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryContentViewController.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "StoryCommentsViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface StoryContentViewController ()
{
    UILabel *contentLabel;
    NSString *petImageId;
    float height;
    BOOL isGood ;//是否点赞 0:未点赞 1 点赞
    BOOL _hasComments;
    
    UILabel *_animateLabel;
}
@end

@implementation StoryContentViewController
/**
 *  通过
 *
 *  @param imageId     当前页面的id
 *  @param hasComments yes：用评论按钮  no：没有按钮评论
 *
 *  @return id
 */
-(id)initWithID:(NSString *)imageId hasComments:(BOOL)hasComments{
    self = [super init];
    if (self) {
        petImageId = imageId;
        height= 0 ;
        _hasComments = hasComments;
    }
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 读取参数
//    NSNumber *readCount = [myUserDefaults objectForKey:UD_userID_Str];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:petImageId forKey:@"knowledgeListId"];
//    [dic setValue:readCount forKey:@"userId"];
    _backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+49)];
    [self.view addSubview:_backgroundScrollView];
//    解析数据
    [self getDate:URL_Pet_Photo andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        int a = [code intValue];
        if(a==0)
        {
            height = 20;
            NSArray *arr=[responseObject objectForKey:@"knowledge"];
            if (arr == [NSNull null]) {
                self.bgStr = Tenyea_str_load_error;
                return ;
            }
            self.petImageViewURL=[arr[0] objectForKey:@"knowledgeImg"];
            
            self.petPresentation=[arr[0] objectForKey:@"knowledgeText"];
//            照片
            if (![_petImageViewURL isEqualToString:@""]) {
                _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 20, ScreenWidth - 80, 120)];
                [_backgroundScrollView addSubview:_contentImageView];
                [_contentImageView setImageWithURL:[NSURL URLWithString:_petImageViewURL]];
                height += 140;
            }
//            文字描述
            if (![_petPresentation isEqualToString:@""]) {
                // 根据内容大小设置label大小
                contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, height, ScreenWidth - 40, 0)];
                contentLabel.text=_petPresentation;
                contentLabel.font=FONT(12);
                contentLabel.numberOfLines = 0;
//                计算高度
                CGSize size = [_petPresentation boundingRectWithSize:CGSizeMake(ScreenWidth - 40, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
                contentLabel.height = size.height;
                [_backgroundScrollView addSubview:contentLabel];
                height += size.height + 40;

            }
//            是否有评论
            if (_hasComments) {
                NSArray *arr = @[@"评论",@"喜欢"];//,@"分享"
                for (int i = 0 ; i < arr.count;  i ++ ) {
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + i *80, height, 60, 30)];
                    button.tag = 100 + i ;
                    button.backgroundColor = [UIColor redColor];
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                    [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:arr[i] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_backgroundScrollView addSubview:button];
                }
            }
            else{
                NSArray *arr = @[@"喜欢"];//,@"分享"
                for (int i = 0 ; i < arr.count;  i ++ ) {
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + i *80, height, 60, 30)];
                    button.tag = 101 + i ;
                    button.backgroundColor = [UIColor redColor];
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                    [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:arr[i] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_backgroundScrollView addSubview:button];
                }
            }
            
            height += 50;
            isGood = [[responseObject objectForKey:@"isGood"] boolValue];
//            未点赞
            if ( !isGood ) {
                
            }
//            已点赞
            else{
                UIButton *button = (UIButton *)VIEWWITHTAG(_backgroundScrollView, 101);
                [button setTitle:@"已喜欢" forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor grayColor]];
            }
            if (height > ScreenHeight) {
                _backgroundScrollView.contentSize = CGSizeMake(ScreenWidth, height);
            }else{
                _backgroundScrollView.height = ScreenHeight;
            }
        }else if(a==1001)
        {
            self.bgStr = Tenyea_str_load_error;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];
    
}

/**
 *  按钮点击事件
 *
 *  @param button 点击的按钮
 */
- (void)selectAction:(UIButton *)button {
    
    switch (button.tag) {
        case 100:{
            [self commentsAction];
            break;
        }
        case 101:{
            
            [self likeAction];
            break;
        }
        case 102:{
            [self shareAction];
            break;
        }
            
        default:
            break;
    }
}
/**
 *  进入评论页
 */
-(void)commentsAction{
    [self.navigationController pushViewController:[[StoryCommentsViewController alloc] initWithPetId:petImageId] animated:YES];
}
/**
 *  点赞的事件
 */
- (void)likeAction {
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    
    // 读取
    NSString *userId = [myUserDefaults objectForKey:UD_userID_Str];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:petImageId forKey:@"petPhotoId"];
    [dic setValue:userId forKey:@"userId"];
    
    
    [self getDate:URL_Like andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];        
        int a = [code intValue];
        if(a==0)
        {
            isGood = !isGood;
            if ( !isGood) {
                UIButton *button = (UIButton *)VIEWWITHTAG(_backgroundScrollView, 101);
                [button setTitle:@"喜欢" forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor redColor]];
                [self labelAnimate:@"-1"];
            }else{
                UIButton *button = (UIButton *)VIEWWITHTAG(_backgroundScrollView, 101);
                [button setTitle:@"已喜欢" forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor grayColor]];
                [self labelAnimate:@"+1"];

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
    if (!_animateLabel) {
        UIButton *button = (UIButton *)VIEWWITHTAG(_backgroundScrollView, 101);
        _animateLabel =[[UILabel alloc]init];
        _animateLabel.font = FONT(12);
        _animateLabel.textColor = [UIColor grayColor];
        _animateLabel.height = 13;
        _animateLabel.width = 12;
        _animateLabel.right = button.width;
        [button addSubview:_animateLabel];
    }
    _animateLabel.top = -13;
    _animateLabel.alpha = 1;
    _animateLabel.text = text;
    [UIView animateWithDuration:1.2 animations:^{
        _animateLabel.top =  - 23;
        _animateLabel.alpha = 0;
    } ];
}

@end
