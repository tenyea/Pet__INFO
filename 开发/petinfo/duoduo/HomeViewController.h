//
//  HomeViewController.h
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
#import "XLCycleScrollView.h"
@interface HomeViewController : TenyeaBaseViewController<XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    //轮播图
    UIPageControl *pageControl;
    UIView *view;
    NSDictionary *result ;
    NSString *petPhotoId ;
    NSString *petPhotoPathMin ;
    NSString *petPhotoTitle ;
    NSString *petPhotoDes ;
    NSString *petPhotoGood ;
    
    
    NSArray *petEveryday ;
    NSDictionary *petDay ;
    NSString *petPhotoId1 ;
    NSString *petPhotoTime ;
    NSString *petPhotoTitle1 ;
    NSString *userName ;
    NSString *userHead ;
    
    
    
    NSArray *result1 ;
    NSDictionary *ad ;
    NSString *adId ;
    NSString *adTitle ;
    NSString *adImage ;
    NSString *adUrl ;

}
@property(nonatomic,strong)UIView *view;
@property(nonatomic,copy)NSDictionary *result;
@property(nonatomic,copy)NSArray *petEveryday;
@property(nonatomic,copy)NSArray *result1;

@end
