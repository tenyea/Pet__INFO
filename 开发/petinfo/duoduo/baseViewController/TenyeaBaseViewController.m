//
//  TenyeaBaseViewController.m
//  duoduo
//
//  Created by tenyea on 14-3-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TenyeaBaseNavigationViewController.h"
@interface TenyeaBaseViewController ()
{
    UILabel *_titleLabel;
    UILabel *_bgLabel;
}
@end

@implementation TenyeaBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"宠信";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *VCS = self.navigationController.viewControllers;
    if (VCS.count > 1) {
        [self needReturnButton];

    }
}

-(void)setBgStr:(NSString *)bgStr{
    if (!_bgStr) {
        _bgLabel = [[UILabel alloc]init];
        _bgLabel.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
        _bgLabel.textAlignment = NSTextAlignmentCenter;
        _bgLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgLabel];
    }
    _bgStr = bgStr;
    _bgLabel.text = bgStr;
    [self.view bringSubviewToFront:_bgLabel];
}



-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    return  appDelegate;
}

#pragma mark -
#pragma mark Data
//访问网络获取数据
//cachePolicyType 0:只读本地数据 。NSURLRequestReturnCacheDataDontLoad 只使用cache数据，如果不存在cache，请求失败;用于没有建立网络连接离线模式;
//                1:本地于与网络比较。NSURLRequestReloadRevalidatingCacheData验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据。
-(void)getDate: (NSString *)url andParams:(NSDictionary *)param  andcachePolicy:(int)cachePolicyType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *baseurl = [BASE_URL stringByAppendingPathComponent:url];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    switch (cachePolicyType) {
        case 0:
            manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            
            break;
        case 1:
            manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
            break;
        default:
            break;
    }
    [manager GET:baseurl parameters:param success:success failure:failure ];
}
#pragma mark -
#pragma mark UI
-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.font=[UIFont boldSystemFontOfSize:18.0f];
    titlelabel.backgroundColor= CLEARCOLOR;
    titlelabel.text=title;
    titlelabel.textColor=TextColor;
    [titlelabel sizeToFit];
    self.navigationItem.titleView = titlelabel;
}
//显示加载提示
-(void)showHUDinView:(NSString *)title{
    if (!HudBgView) {
        HudBgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - 260)/2, (ScreenHeight - 100)/2 -100, 260, 100)];
        HudBgView.backgroundColor = CLEARCOLOR;
        [self.view addSubview:HudBgView];
        [self showHUDwithLabel:title inView:HudBgView];
    }
}
-(void)showHUDwithLabel:(NSString *)title inView:(UIView *)view{
    if (!HUD) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if (title) {
            HUD.labelText = title;
        }else {
            HUD.labelText = button_loading;
        }
        [HUD show:YES];
    }
}



-(void)showHudInBottom:(NSString *)title{
    HudBgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - 200)/2, (ScreenHeight - 100)/2 , 200, 30)];
    [self.view addSubview:HudBgView];
    [self showHUDwithLabel:title inView:HudBgView];
    HudBgView.backgroundColor = [UIColor grayColor];
	HUD.mode = MBProgressHUDModeText;
    HUD.labelColor = [UIColor whiteColor];
    HUD.color = [UIColor grayColor];
	HUD.removeFromSuperViewOnHide = YES;
	
}
//隐藏移除加载框
-(void)removeHUD{
    if (HudBgView) {
        [HudBgView removeFromSuperview];
        HudBgView = nil;
    }
    [HUD hide:YES];
    [HUD removeFromSuperview];
    HUD= nil;
}

//需要返回按钮
-(void)needReturnButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
//    [self setLeftButton: button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
//返回事件
-(void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
