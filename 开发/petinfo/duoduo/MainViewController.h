//
//  MainViewController.h
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TenyeaBaseNavigationViewController.h"
#import "BMKLocationService.h"

@interface MainViewController : UITabBarController<UINavigationControllerDelegate,BMKLocationServiceDelegate>
{
    UIView *_tabbarView;//tabbar
    BMKLocationService *_locService;//定位服务
    
}
-(void)setTabbarShow:(BOOL)isshow;
@end
