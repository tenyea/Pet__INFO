//
//  NearPetDetailVC.m
//  宠信
//
//  Created by tenyea on 14-8-20.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "NearPetDetailVC.h"

@interface NearPetDetailVC ()
{
    NSDictionary *_userInfo ;
}
@end

@implementation NearPetDetailVC

-(id)initWithuserInfo:(NSDictionary *)userInfo{
    if (self = [super init]) {
        _userInfo = userInfo;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
