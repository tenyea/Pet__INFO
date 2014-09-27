//
//  ADWebViewController.m
//  宠信
//
//  Created by __ on 14-8-4.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ADWebViewController.h"

@interface ADWebViewController ()

@end

@implementation ADWebViewController
@synthesize webView=webView;
@synthesize url=url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 480-108)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
