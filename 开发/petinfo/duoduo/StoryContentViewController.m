//
//  StoryContentViewController.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryContentViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
@interface StoryContentViewController ()
{
    UILabel *contentLabel;
}
@end

@implementation StoryContentViewController
@synthesize likeButton=_likeButton;
@synthesize photoID=_photoID;
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
    
    // 根据内容大小设置label大小
    contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.text=_petPresentation;
    contentLabel.font=[UIFont systemFontOfSize:12];
       [self.view addSubview:contentLabel];
    // 计算内容大小
    CGSize contentSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(300, 10000) lineBreakMode:NSLineBreakByWordWrapping];
   
    
    contentLabel.numberOfLines = 0;
   
    _po(_petPresentation);
    
  
    // Do any additional setup after loading the view from its nib.
    _backgroundScrollView.contentSize=CGSizeMake(320, 20000);
    NSURL *url = [NSURL URLWithString:_petImageViewURL];
     [_contentImageView setImageWithURL:url placeholderImage:nil];
    if ([_petImageViewURL isEqualToString:@""]) {
        contentLabel.frame = CGRectMake(10, 74, contentSize.width, contentSize.height);
       
    }else
    {
         contentLabel.frame = CGRectMake(10, 210, contentSize.width, contentSize.height);
    
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commentsButton:(id)sender {
   }

- (IBAction)likeButton:(id)sender {
    NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
    
    // 读取
    NSNumber *readCount = [myUserDefaults objectForKey:UD_userID_Str];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_photoID forKey:@"petPhotoId"];
    [dic setValue:readCount forKey:@"userId"];
    
    
    [self getDate:URL_Like andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        NSLog(@"%@",code);
        
        int a = [code intValue];
        if(a==0)
        {
            _po(@"111");
            _likeButton.enabled=NO;
//            _likeButton.titleLabel.font=[UIFont systemFontOfSize:8];
//            _likeButton.titleLabel.text=@"不喜欢";
            
            NSLog(@"登录成功");
        }else
        {
            // 去登陆  缺少userID
            [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

- (IBAction)shareButton:(id)sender {
}
@end
