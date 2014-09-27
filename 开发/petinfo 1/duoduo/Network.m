//
//  Network.m
//  duoduo
//
//  Created by tenyea on 14-3-27.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "Network.h"
#import "Reachability.h"

@implementation Network

// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
//判断当前是否有网络
+(NSString *) getConnectionAvailable{
    NSString *isExistenceNetwork = @"none";
    Reachability *reach = [Reachability reachabilityWithHostName:Host];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = @"none";
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = @"wifi";
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = @"3g";
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

//判断当前是否有网络
+(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:Host];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

@end
