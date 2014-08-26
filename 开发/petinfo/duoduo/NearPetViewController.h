//
//  NearPetViewController.h
//  宠信
//
//  Created by __ on 14-8-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
#import "BMapKit.h"
/**
 *  附近宠物的页面
 */
@interface NearPetViewController : TenyeaBaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* baiduMapView;

}


@end
