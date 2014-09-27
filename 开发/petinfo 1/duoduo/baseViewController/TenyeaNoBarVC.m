//
//  TenyeaNoBarVC.m
//  宠信
//
//  Created by tenyea on 14-8-13.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaNoBarVC.h"

@interface TenyeaNoBarVC ()

@end

@implementation TenyeaNoBarVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.appDelegate.mainVC setTabbarShow:NO animate:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.appDelegate.mainVC setTabbarShow:YES animate:NO];
}
@end
