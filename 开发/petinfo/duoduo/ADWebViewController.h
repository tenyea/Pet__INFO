//
//  ADWebViewController.h
//  宠信
//
//  Created by __ on 14-8-4.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface ADWebViewController : TenyeaBaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy)NSString *url;
@end
