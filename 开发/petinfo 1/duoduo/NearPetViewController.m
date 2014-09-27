//
//  NearPetViewController.m
//  宠信
//
//  Created by __ on 14-8-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "NearPetViewController.h"
#import "BMKMapView.h"
#import "CustomBMKPointAnnotation.h"
#import "CustomBMKAnnotationView.h"
#import "CustomView.h"
#import "ShowBMKAnnotationView.h"
@interface NearPetViewController ()
{
    NSArray *_userArr; //用户解析数据
    NSArray *_locationArr; //用户坐标
    
    CustomBMKPointAnnotation *_customAnnotation;
    CustomBMKAnnotationView *_customAnnotationView;
}
@end

@implementation NearPetViewController

-(id)init{
    if (self =  [super init]) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDate) name:NC_location_Success  object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDate) name:NC_location_Fail  object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *dic = [userDefaults dictionaryForKey:UD_Locationnow_DIC];
    if (!dic) {
        self.bgStr = @"请打开定位,才能使用本功能";
        return;
    }
    
    //    中心点
    double longitude = [[dic objectForKey:@"longitude"] doubleValue];
    double latitude =[[dic objectForKey:@"latitude"] doubleValue];
    CLLocationCoordinate2D location ;
    location.latitude = latitude;
    location.longitude = longitude;
 
 
//初始化地图
    baiduMapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:baiduMapView];
//    地图比例尺级别
    [baiduMapView setZoomLevel:16];
//    显示比例尺
    baiduMapView.showMapScaleBar = YES;
    baiduMapView.mapScaleBarPosition = CGPointMake(ScreenWidth - 50, ScreenHeight- 40 -64 );
//    设置中心点
    baiduMapView.centerCoordinate = location;
    
    baiduMapView.delegate = self;

    

    [self getDate:latitude longitude:longitude];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.appDelegate.mainVC setTabbarShow:NO animate:NO];
    [baiduMapView viewWillAppear];
    baiduMapView.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.appDelegate.mainVC setTabbarShow:YES animate:NO];
    [baiduMapView viewWillDisappear];
    baiduMapView.delegate = nil;

}

#pragma mark -
#pragma mark method
/**
 *  根据坐标，获取数据
 *
 *  @param latitude latitude
 *  @param longitude longitude
 */
-(void)getDate : (double)latitude longitude:(double)longitude{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:UD_userID_Str];
    [params setObject:userId forKey:@"userId"];
    [params setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [params setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [self getDate:URL_getNearPet andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ( [[responseObject objectForKey:@"code"] intValue] == 0 ) {
            _userArr = [responseObject objectForKey:@"user"];
            
            
            
            for (int i = 1 ; i <= _userArr.count ; i ++ ) {
                NSDictionary *dic = _userArr[i-1];
                CustomBMKPointAnnotation *pointAnnotation = [[CustomBMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude = [[dic objectForKey:@"userLatitude" ]  doubleValue];
                coor.longitude = [[dic objectForKey:@"userLongitude"] doubleValue];
                pointAnnotation.coordinate = coor;
                pointAnnotation.userInfo = @{[NSString stringWithFormat:@"%d",i]: dic};
                [baiduMapView addAnnotation:pointAnnotation];
            }

        }else{
            self.bgStr = Tenyea_str_load_error;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];

}

//根据anntation生成对应的View
- ( BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[CustomBMKPointAnnotation class]]) {
        CustomBMKPointAnnotation *pointAnnotation = (CustomBMKPointAnnotation *)annotation;
        if ([annotation isEqual:_customAnnotation]) {
            static NSString *divIdentifier = @"divIdentifier";

            CustomBMKAnnotationView *view =  (CustomBMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:divIdentifier];
            if (view == nil) {
                view = [[CustomBMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:divIdentifier];
                
                CustomView *custView = [[[NSBundle mainBundle]loadNibNamed:@"CustomView" owner:self options:nil] lastObject];
                view.customView = custView;
                [view.contentView addSubview:view.customView];
            }
            NSDictionary *dic = [[pointAnnotation.userInfo allValues] lastObject];
            view.customView.userInfo = dic;
            
            return view;
            
        }else{
            static NSString *mapIdentifier = @"mapIdentifier";
            ShowBMKAnnotationView *view = (ShowBMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:mapIdentifier];
            if (view == nil) {
                view = [[ShowBMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:mapIdentifier];
                
            }
            view.label.text = [[pointAnnotation.userInfo allKeys] lastObject];
            return view;
        }
    }
    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[CustomBMKPointAnnotation class]]) {
        CustomBMKPointAnnotation *pointAnnotation  = (CustomBMKPointAnnotation *)view.annotation;
        //如果点到了这个marker点，什么也不做
        if (_customAnnotation.coordinate.latitude == pointAnnotation.coordinate.latitude && _customAnnotation.coordinate.longitude == pointAnnotation.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_customAnnotation) {
            [baiduMapView removeAnnotation:_customAnnotation];
            _customAnnotation = nil;
        }
        
        //创建搭载自定义calloutview的annotation
        _customAnnotation = [[CustomBMKPointAnnotation alloc] init];
        _customAnnotation.coordinate = pointAnnotation.coordinate;
        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
        _customAnnotation.userInfo = pointAnnotation.userInfo;
        [baiduMapView addAnnotation:_customAnnotation];
        [baiduMapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    }
    
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
//   移除
    if (_customAnnotation&&![view isKindOfClass:[CustomBMKPointAnnotation class]]) {
        
        if (_customAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _customAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [baiduMapView removeAnnotation:_customAnnotation];
            _customAnnotation = nil;
        }
    }
}
@end
