//
//  NearPetViewController.m
//  宠信
//
//  Created by __ on 14-8-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "NearPetViewController.h"
#import "BMKMapView.h"
@interface NearPetViewController ()

@end

@implementation NearPetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    baiduMapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, 320, 400)];
    
    [self.view addSubview:baiduMapView];
     _locService = [[BMKLocationService alloc]init];
    baiduMapView.delegate = self;
    _locService.delegate = self;
    [_locService startUserLocationService];
    baiduMapView.showsUserLocation = NO;//先关闭显示的定位图层
    baiduMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    baiduMapView.showsUserLocation = YES;//显示定位图层
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
