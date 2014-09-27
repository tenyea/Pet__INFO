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

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <CoreLocation/CoreLocation.h>


@interface MainViewController : UITabBarController<UINavigationControllerDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate>
{
    UIView *_tabbarView;//tabbar
    BMKLocationService *_locService;//定位服务
    
}
/**
 *  外部设置tabbar是否显示
 *
 *  @param isshow  yes ：显示 no：不显示
 *  @param animate yes ：有动画 no ： 没动画
 */
-(void)setTabbarShow:(BOOL)isshow animate:(BOOL)animate;
/**
 *  更新选中页
 *
 *  @param selectedIndex 选中页ID
 */
-(void)updateSelectedIndex:(NSUInteger)selectedIndex;
@end
