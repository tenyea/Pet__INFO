//
//  RegisterViewController.m
//  宠信
//
//  Created by tenyea on 14-7-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#define userNameRules @"用户名长度为4-10"
#define passwordRules @"密码长度为6-16"
#define passwordAgainRules @"确认密码不正确"
#define emailRules @"邮箱不符合规范"
#define parametersLost @"请输入完整信息"
#define wrongInformation @"用户名或密码错误"
#define usernamEexisting @"用户名已经注册"
#define emailEexisting @"邮箱已经注册"
#define userNameConditions @"用户名只能是数字、字母、下划线"
@interface RegisterViewController ()
{
    NSString *registeredMessage;
}
@end

@implementation RegisterViewController
@synthesize backgroundView;
@synthesize passwordTF,passwordAgainTF;
@synthesize userNameTF,emailTF;
@synthesize userNameLabel,passwordLabel,passwordAgainLabel,emailLabel;
@synthesize registerBackground;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    userNameTF.delegate=self;
    passwordTF.delegate=self;
    passwordAgainTF.delegate=self;
    emailTF.delegate=self;
    
    userNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordAgainTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    emailTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    
    [userNameTF becomeFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    passwordTF.secureTextEntry=YES;
    passwordAgainTF.secureTextEntry=YES;
}

// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==90001)
    {
        if(userNameTF.text.length<4||userNameTF.text.length>10)
        {
            registeredMessage=userNameRules;
            userNameLabel.text=userNameRules;
        }else
        {
            userNameLabel.text=nil;
        }
        [emailTF becomeFirstResponder];
    }else if(textField.tag==90002)
    {
        if(![self validateEmail:emailTF.text])
        {
            registeredMessage =emailRules;
            NSLog(@"邮箱不合法");
            emailLabel.text=emailRules;
        }else
        {
            emailLabel.text=nil;
        }
        
        [passwordTF becomeFirstResponder];
    }
    
    else if (textField.tag==90003)
    {
        if (passwordTF.text.length<6||passwordTF.text.length>16)
        {
            registeredMessage=passwordRules;
            passwordLabel.text=passwordRules;
        }else
        {
            passwordLabel.text=nil;
        }
        [passwordAgainTF becomeFirstResponder];
    }else if (textField.tag==90004)
    {
        if (![passwordTF.text isEqualToString:passwordAgainTF.text])
        {
            registeredMessage =passwordAgainRules;
            NSLog(@"确认密码不正确");
            passwordAgainLabel.text=passwordAgainRules;
        }else
        {
            passwordAgainLabel.text=nil;
        }
        
        [passwordAgainTF resignFirstResponder];
    }    return YES;
}
// 邮箱格式判断
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


// 注册按钮 点击事件
- (IBAction)registerBtn:(id)sender {
    registeredMessage = nil;
    userNameLabel.text=nil;
    passwordLabel.text=nil;
    passwordAgainLabel.text=nil;
    emailLabel.text=nil;
    if([passwordAgainTF.text isEqualToString:passwordTF.text])
    {
        if (!registeredMessage) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:userNameTF.text forKey:@"username"];
            [dic setValue:passwordTF.text forKey:@"password"];
            [dic setValue:emailTF.text forKey:@"email"];
            
            [self getDate:URL_RegisterServlet andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *code = [responseObject objectForKey:@"code"];
                NSLog(@"code = %@",code);
                
                int a = [code intValue];
                if(a==0)
                {
                    [self showHudInBottom:@"注册成功"];
                    [self performSelector:@selector(timerFiredSuccess:) withObject:nil afterDelay:1.5];
                    return ;
                }else if(a==1001)
                {
                    registeredMessage =parametersLost;
                    NSLog(@"请输入完整信息");
                    
                }else if(a==1003)
                {
                    registeredMessage =usernamEexisting;
                    NSLog(@"用户名已经注册");
                }else if(a==1004)
                {
                    registeredMessage =emailEexisting;
                    NSLog(@"邮箱已经注册");
                    emailLabel.text=emailEexisting;
                }else if(a==1005)
                {
                    registeredMessage =userNameRules;
                    NSLog(@"用户名4-10位");
                    userNameLabel.text=userNameRules;
                }else if(a==1006)
                {
                    registeredMessage =passwordRules;
                    NSLog(@"密码（6-16位）");
                    passwordLabel.text=passwordRules;
                }else if(a==1007)
                {
                    registeredMessage =userNameConditions;
                    NSLog(@"用户名非法");
                    userNameLabel.text=userNameConditions;
                }else if(a==1008)
                {
                    registeredMessage =emailRules;
                    NSLog(@"邮箱格式不正确");
                    emailLabel.text=emailRules;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [error localizedFailureReason];
                _po([error localizedDescription]);
            }];
        }
    }else {
        _po(@"确认密码不正确");
        passwordAgainLabel.text=passwordAgainRules;
    }
    
}
// 注册成功取消HUD,跳转界面
-(void)timerFiredSuccess:(NSTimer *)timer{
    [self removeHUD];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

