//
//  UpdatePasswordViewController.m
//  宠信
//
//  Created by tenyea on 14-7-21.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UpdatePasswordViewController.h"

#define passwordRules @"密码长度为6-16"
#define passwordAgainRules @"确认密码不正确"
@interface UpdatePasswordViewController ()
{
    NSString *registeredMessage;
}
@end

@implementation UpdatePasswordViewController

@synthesize secondPass = secondPass,secondLabel = secondLabel;
@synthesize firstPass = firstPass ,firstLabel = firstLabel;
- (void)viewDidLoad
{
    [super viewDidLoad];

    firstPass.clearButtonMode=UITextFieldViewModeWhileEditing;
    firstPass.delegate = self;
    firstPass.secureTextEntry=YES;
    
    secondPass.clearButtonMode=UITextFieldViewModeWhileEditing;
    secondPass.delegate = self;
    [firstPass becomeFirstResponder];
    secondPass.secureTextEntry=YES;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)returnAction{
    [self popVC];
}
-(void)submitAction{
    if([firstPass.text isEqualToString:secondPass.text])
    {
        if (registeredMessage) {
            return;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:firstPass.text forKey:@"password"];
        [dic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
        [self getDate:URL_UpdatePassword andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _po([error localizedDescription]);
            [self popVC];
        }];
        
        
    }else{
        _po(@"确认密码不正确");
        secondLabel.text=passwordAgainRules;
    }
    
}

// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==90003)
    {
        if (firstPass.text.length<6||firstPass.text.length>16)
        {
            registeredMessage=passwordRules;
            firstLabel.text=passwordRules;
        }else
        {
            firstLabel.text=nil;
        }
        [secondPass becomeFirstResponder];
    }else if (textField.tag==90004)
    {
        if (![secondPass.text isEqualToString:secondPass.text])
        {
            registeredMessage =passwordAgainRules;
            NSLog(@"确认密码不正确");
            secondLabel.text=passwordAgainRules;
        }else
        {
            secondLabel.text=nil;
        }
        
        [self submitAction];
    }
    return YES;
}

-(void)popVC {
    //    返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
