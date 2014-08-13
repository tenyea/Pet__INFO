//
//  MainViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "StoryViewController.h"
#import "AskViewController.h"
#import "MyViewController.h"
@interface MainViewController ()
{
    int _tabbar_button_select ;
    NSDictionary *main_result ;
 
    NSArray *main_petEveryday ;
 
    NSArray *main_result1 ;
    
    NSDictionary *story_result;
    
    StoryViewController *story;
}
@end

@implementation MainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getDate:URL_Ao andParams:nil andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        
        int a = [code intValue];
        if(a==0)
        {
            [self showResult:responseObject];
            NSLog(@"登录成功");
            //初始化子控制器
            [self _initController];
            //初始化tabbar
            [self _initTabbarView];
            
            //    定位
            [self Location];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
#pragma mark Location
//定位
-(void)Location {

    
    _locService =  [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
//    [_locService stopUserLocationService];

}
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


-(void)showResult:(NSDictionary *)resultobject
{
    //解析数据
    main_result =[resultobject objectForKey:@"weekPetPhoto"];
    
    main_petEveryday = [resultobject objectForKey:@"petPhotoList"];
   
    main_result1 =[resultobject objectForKey:@"ad"];
    
    
}

#pragma mark -
#pragma mark init
//初始化子控制器
-(void)_initController{
   
    HomeViewController *home=[[HomeViewController alloc]init];
    home.result=main_result;
    home.petEveryday=main_petEveryday;
    home.result1=main_result1;

    story=[[StoryViewController alloc]init];
    AskViewController *ask=[[AskViewController alloc]init];
    MyViewController *my=[[MyViewController alloc]init] ;
    
    NSArray *views=@[home,story,ask,my];
    NSMutableArray *viewControllers=[NSMutableArray arrayWithCapacity:4];
    for (UIViewController *viewController in views) {
        TenyeaBaseNavigationViewController *navViewController =[[TenyeaBaseNavigationViewController alloc]initWithRootViewController:viewController];
        [viewControllers addObject:navViewController];
        navViewController.delegate = self;
    }
    self.viewControllers=viewControllers;
}
//初始化tabbar
-(void)_initTabbarView{
    [self.tabBar setHidden:YES];
    _tabbarView=[[UIView alloc]init];
    _tabbarView.frame=CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
    _tabbarView.backgroundColor = COLOR(249, 249, 249);
    [self.view addSubview:_tabbarView];
    NSArray *backgroud = @[@"main_home.png",@"main_story.png",@"main_ask.png",@"main_my.png"];
    NSArray *backgroud_selected = @[@"main_home_selected.png",@"main_story_selected.png",@"main_ask_selected.png",@"main_my_selected.png"];
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage =backgroud[i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake( (320/backgroud.count) *i, 0, (320/backgroud.count), 49);
        button.tag=100+i;
        if (i == 0 ) {
            button.selected = YES;
            _tabbar_button_select = button.tag;
        }
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:backgroud_selected[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        //设置高亮
//        [button setShowsTouchWhenHighlighted:YES];
        [_tabbarView addSubview:button];
    }
    
    
}

#pragma mark -
#pragma mark BMKLocationServiceDelegate

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);

    _pf(userLocation.location.coordinate.latitude);
    _pf(userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    CLLocation *location = userLocation.location;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            NSLog(@"locality,%@",place.locality);               // 市
            NSLog(@"subLocality,%@",place.subLocality);         //区
            _po(place.administrativeArea); //省
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@-%@",place.locality,place.subLocality] forKey:UD_nowPosition_Str];
            [[NSUserDefaults standardUserDefaults] setObject:
                            @{@"latitude": [NSNumber numberWithFloat:location.coordinate.latitude],
                              @"longitude":[NSNumber numberWithFloat:location.coordinate.longitude]}
                                                      forKey:UD_Locationnow_DIC];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

    }];
}
//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    CLLocation *location = userLocation.location;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            NSLog(@"locality,%@",place.locality);               // 市
            NSLog(@"subLocality,%@",place.subLocality);         //区
            _po(place.administrativeArea); //省
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@-%@",place.locality,place.subLocality] forKey:UD_nowPosition_Str];
            [[NSUserDefaults standardUserDefaults] setObject:
             @{@"latitude": [NSNumber numberWithFloat:location.coordinate.latitude],
               @"longitude":[NSNumber numberWithFloat:location.coordinate.longitude]}
                                                      forKey:UD_Locationnow_DIC];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    }];

}

#pragma mark -
#pragma mark 按钮事件
//tabbar选中事件
-(void)selectedTab:(UIButton *)button
{
    if (_tabbar_button_select) {
        UIButton *button = (UIButton *)VIEWWITHTAG(_tabbarView, _tabbar_button_select);
        button.selected = NO;
    }
    _tabbar_button_select = button.tag;
    int site = button.tag - 100;
    button.selected = YES;
    self.selectedIndex = site;
    if (site==1) {
       // button.selected=YES;
       // story.rowHeigh=89;
        _po(@"111");
        [story loadData];

    }
}

#pragma mark -
#pragma mark method
-(void)setTabbarShow:(BOOL)isshow{
    if (isshow) {
        [UIView animateWithDuration:.3 animations:^{
            _tabbarView.transform = CGAffineTransformIdentity;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            _tabbarView.transform = CGAffineTransformTranslate(_tabbarView.transform, 0, _tabbarView.height);
        }];
    }
}
@end
