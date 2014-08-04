//
//  Network.h
//  duoduo
//
//  Created by tenyea on 14-3-27.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject
//判断当前网络环境
+(NSString *) getConnectionAvailable;
//判断当前是否有网络
+(BOOL) isConnectionAvailable;
// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否3G
+ (BOOL) IsEnable3G;
@end
