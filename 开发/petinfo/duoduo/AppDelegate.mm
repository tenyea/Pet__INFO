//
//  AppDelegate.m
//  duoduo
//
//  Created by tenyea on 14-3-25.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@implementation AppDelegate

#pragma mark method
/**
 *  注册sharesdk 相关组件
 */
-(void)regShareSdk{
    //参数为ShareSDK官网中添加应用后得到的AppKey
    [ShareSDK registerApp: shareSdkAppID];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           wechatCls:[WXApi class]];
}

#pragma mark -
#pragma mark Appdelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    sleep(1);
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 注册通知（声音、标记、弹出窗口）
    if(!application.enabledRemoteNotificationTypes){
        NSLog(@"Initiating remoteNoticationssAreActive1");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }

    [application  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
//    if (launchOptions !=nil) {
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        NSString *newsId = [userInfo objectForKey:@"newsId"];
//        if (newsId) {
//            NSDictionary *dic = @{@"newsId":newsId,
//                                  @"title": alertString,
//                                  @"newsAbstract":[userInfo objectForKey:@"newsAbstract"],
//                                  @"type":[userInfo objectForKey:@"type"],
//                                  @"img":[userInfo objectForKey:@"img"]==nil?@"":[userInfo objectForKey:@"img"]
//                                  };
//            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//            [userdefaults setObject:dic forKey: kServletPush_Model ];
//            [userdefaults synchronize];
//            [self performSelector:@selector(pushmodel) withObject:nil afterDelay:6];
//        }
//    }

    //    地图
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"2OI1WuFGWufTPArmmnUtZ4wL"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [self regShareSdk];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainVC = [[MainViewController alloc]init];
    self.window.rootViewController = self.mainVC;
    [self.window makeKeyAndVisible];
    

    //设置百度推送代理
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    //设置角标为0
    [application setApplicationIconBadgeNumber:0];
    
//    //已经使用过的用户
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:kbundleVersion]) {
//        
//        //设置文件初始化
//        NSString *settingPath = [[FileUrl getDocumentsFile] stringByAppendingPathComponent: kSetting_file_name];
//        [[NSFileManager defaultManager] createFileAtPath: settingPath contents: nil attributes: nil];
//        //设置文件信息
//        NSMutableDictionary *settingDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: 1], kFont_Size, [NSNumber numberWithBool: YES], KNews_Push, nil];
//        [settingDic writeToFile: settingPath atomically: YES];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}


//注册token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [BPush registerDeviceToken: deviceToken];
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:BPushappid] ==nil||[[[NSUserDefaults standardUserDefaults]objectForKey:BPushappid]isEqualToString:@""]) {
//        //绑定
//        [BPush bindChannel];
//    }
}

//后台激活后 移除推送信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
//    NSString *alertString = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    if (application.applicationState == UIApplicationStateActive) {
//        NSString *newsId = [userInfo objectForKey:@"newsId"];
//        if (newsId) {
//            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送新闻:"
//                                                                message:[NSString stringWithFormat:@"%@", alertString]
//                                                               delegate:self
//                                                      cancelButtonTitle:@"好的"
//                                                      otherButtonTitles:@"查看",nil];
//            ColumnModel *model = [[ColumnModel alloc]init];
//            model.newsId = newsId;
//            model.title = alertString;
//            model.newsAbstract = [userInfo objectForKey:@"newsAbstract"];
//            model.type = [userInfo objectForKey:@"type"];
//            model.img = [userInfo objectForKey:@"img"];
//            model.isselected = NO;
//            _pushModel = model;
//            [alertView show];
//        }else{
//            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送新闻:"
//                                                                message:[NSString stringWithFormat:@"%@", alertString]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//            [alertView show];
//            
//        }
//    }else if (application.applicationState == UIApplicationStateInactive){//进入激活状态  默认查看新闻
//        NSString *newsId = [userInfo objectForKey:@"newsId"];
//        if (newsId) {
//            ColumnModel *model = [[ColumnModel alloc]init];
//            model.newsId = newsId;
//            model.title = alertString;
//            model.newsAbstract = [userInfo objectForKey:@"newsAbstract"];
//            model.type = [userInfo objectForKey:@"type"];
//            model.img = [userInfo objectForKey:@"img"];
//            model.isselected = NO;
//            _pushModel = model;
//            [[NSNotificationCenter defaultCenter]postNotificationName:kPushNewsNotification object:_pushModel];
//        }
//        
//    }
//    [application setApplicationIconBadgeNumber:0];
//    [BPush handleNotification:userInfo];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}


#pragma mark pushdelegate  回调函数
- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
//    NSLog(@"On method:%@", method);
//    NSLog(@"data:%@", [data description]);
//    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
//    if ([BPushRequestMethod_Bind isEqualToString:method]) {//绑定
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
//        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
//        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
//        if (returnCode == BPushErrorCode_Success) {
//            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//            [user setValue:appid forKey:BPushappid];
//            [user setValue:userid forKey:BPushuserid];
//            [user setValue:channelid forKey:BPushchannelid];
//            //同步
//            [user synchronize];
//            
//        }
//    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {//解除绑定
//        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
//        if (returnCode == BPushErrorCode_Success) {
//            NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
//            [user removeObjectForKey:BPushchannelid];
//            [user removeObjectForKey:BPushuserid];
//            [user removeObjectForKey:BPushappid];
//            //同步
//            [user synchronize];
//        }
//    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //设置角标为0
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 *  用于sharesdk打开应用
 *
 *  @param application <#application description#>
 *  @param url         <#url description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
#pragma mark -
#pragma mark BMKGeneralDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
