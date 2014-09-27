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
#define pageVersion 1
@interface MainViewController ()
{
    int _tabbar_button_select ;
    NSDictionary *main_result ;
 
    NSArray *main_petEveryday ;
 
    NSArray *main_result1 ;
    
    NSDictionary *story_result;
    
    StoryViewController *story;
    /**
     *  引导页视图
     */
    UIScrollView *_scrollView;
}
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化子控制器
    [self _initController];
    //初始化tabbar
    [self _initTabbarView];
    //    定位
    [self Location];
    /**
     *  当userdefaults中的pageversion与当前不符时，显示引导图
     */
    if ([[NSUserDefaults standardUserDefaults] integerForKey:UD_pageVersion] != pageVersion) {
        //    引导图
        [self _initBootView];
    }
    
    
}
#pragma mark boot
/**
 *  实例化引导图
 */
-(void)_initBootView{
    NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
    for ( int i = 1 ; i < 4; i ++ ) {
        NSString *imageName = [NSString stringWithFormat:@"%dx%d-%d.png",(int)(ScreenWidth*2),(int)(ScreenHeight*2),i];
        [imageNameArray addObject:imageName];
    }
    //引导页
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _scrollView.contentSize = CGSizeMake(320 *imageNameArray.count , ScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    //增加引导页图片
    for (int i = 0 ; i < imageNameArray.count  ; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*320 , 0, ScreenWidth, ScreenHeight);
        [imageView setImage:[UIImage imageNamed:imageNameArray[i]]];
        [_scrollView addSubview:imageView];
    }
    //进入主界面按钮
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.numberOfLines = 2;
    button.backgroundColor = CLEARCOLOR;
    button.titleLabel.backgroundColor = CLEARCOLOR;
    [button setImage:[UIImage imageNamed:@"go_main.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(320*imageNameArray.count - 160 - 136/2, ScreenHeight-50, 136, 37);
    [_scrollView addSubview:button];
    
    [self.view addSubview:_scrollView];
    
    //增加pageview
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.frame = CGRectMake((ScreenWidth-100)/2, ScreenHeight -80, 100, 30);
    pageControl.tag = 1300;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = COLOR(0, 229, 223);
    pageControl.currentPage = 0 ;
    pageControl.numberOfPages = imageNameArray.count;
    pageControl.backgroundColor = [UIColor clearColor];
    [pageControl addTarget:self action:@selector(pageindex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}

#pragma mark scrolldelegate
/**
 *  引导图滚动事件
 *
 *  @param scrollView 当前引导图
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pageindex = scrollView.contentOffset.x / 320 ;
    UIPageControl *pageControl = (UIPageControl *) [self.view viewWithTag:1300];
    pageControl.currentPage = pageindex;
}
#pragma mark 按钮事件
/**
 *  最后一张引导图的按钮时间。点击后隐藏引导图
 */
- (void)enter{
    UIPageControl *pageControl = (UIPageControl *)[self.view viewWithTag:1300] ;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.alpha = 0 ;
        pageControl.alpha = 0 ;
    } completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:pageVersion] forKey:UD_pageVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (finished) {
            [pageControl removeFromSuperview];
            [_scrollView removeFromSuperview];
        }
    }];
}
/**
 *  pagecontrol 事件
 *
 *  @param pagecontrol <#pagecontrol description#>
 */
- (void)pageindex:(UIPageControl *)pagecontrol{
    CGRect frame = CGRectMake(pagecontrol.currentPage* ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [_scrollView scrollRectToVisible:frame animated:YES];
}
#pragma mark Location
/**
 *  开始定位，定位完成后需要将代理设置为空
 */
-(void)Location {
    _locService =  [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}
/**
 * 访问网络获取数据
 * cachePolicyType 0:只读本地数据 。NSURLRequestReturnCacheDataDontLoad 只使用cache数据，如果不存在cache，请求失败;用于没有建立网络连接离线模式;
 *                 1:本地于与网络比较。NSURLRequestReloadRevalidatingCacheData验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据。
 */
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
#pragma mark init
//初始化子控制器
-(void)_initController{
   
    HomeViewController *home=[[HomeViewController alloc]init];
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
        [button setImage:[UIImage imageNamed:backgroud_selected[i]] forState:UIControlStateHighlighted];


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
                            @{@"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
                              @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude]}
                                                      forKey:UD_Locationnow_DIC];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            [[NSNotificationCenter defaultCenter]postNotificationName:NC_location_Success object:nil userInfo:nil];
            _locService.delegate = nil;

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
             @{@"latitude": [NSNumber numberWithDouble :location.coordinate.latitude],
               @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude]}
                                                      forKey:UD_Locationnow_DIC];
            [[NSUserDefaults standardUserDefaults]synchronize];
//            [[NSNotificationCenter defaultCenter]postNotificationName:NC_location_Success object:nil userInfo:nil];
            _locService.delegate = nil;

        }
    }];

}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    _po([error localizedDescription]);
    [_locService stopUserLocationService];
//    [[NSNotificationCenter defaultCenter]postNotificationName:NC_location_Fail object:nil userInfo:nil];
    _locService.delegate = nil;

}
#pragma mark -
#pragma mark 按钮事件
//tabbar选中事件
//当第二个按钮点击是。刷新其页面的数据
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
//    当第二个按钮点击是。刷新其页面的数据
//    if (site==1) {
//       // button.selected=YES;
//       // story.rowHeigh=89;
//        [story refreshData];
//
//    }
}
/**
 *  更新选中页
 *
 *  @param selectedIndex 选中页ID
 */
-(void)updateSelectedIndex:(NSUInteger)selectedIndex{
    if (_tabbar_button_select) {
        UIButton *button = (UIButton *)VIEWWITHTAG(_tabbarView, _tabbar_button_select);
        button.selected = NO;
    }
    _tabbar_button_select = 100 + selectedIndex;
    UIButton *button = (UIButton *)VIEWWITHTAG(_tabbarView, _tabbar_button_select);
    button.selected = YES;
    self.selectedIndex = selectedIndex;
}
#pragma mark -
#pragma mark method
/**
 *  设置tabbar是否显示
 *
 *  @param isshow  yes ：显示 no：不显示
 *  @param animate yes ：有动画 no ： 没动画
 */
-(void)setTabbarShow:(BOOL)isshow animate:(BOOL)animate{
    if (animate) {
        if (isshow) {
            [UIView animateWithDuration:.3 animations:^{
                _tabbarView.transform = CGAffineTransformIdentity;
            }];
        }else{
            [UIView animateWithDuration:.3 animations:^{
                _tabbarView.transform = CGAffineTransformTranslate(_tabbarView.transform, 0, _tabbarView.height);
            }];
        }
    }else{
        if (isshow) {
            _tabbarView.transform = CGAffineTransformIdentity;
        }else{
            _tabbarView.transform = CGAffineTransformTranslate(_tabbarView.transform, 0, _tabbarView.height);
        }
    }
    
}
@end
