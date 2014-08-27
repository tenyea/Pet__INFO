//
//  UpdatePasswordVC.m
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UpdatePasswordVC.h"
#define passwordRules @"密码长度为6-16"
#define passwordAgainRules @"确认密码不正确"
@interface UpdatePasswordVC ()

@end

@implementation UpdatePasswordVC
@synthesize secondPass = secondPass,secondLabel = secondLabel;
@synthesize firstPass = firstPass ,firstLabel = firstLabel;
@synthesize originalLabel = originalLabel, originalPass = originalPass;
- (void)viewDidLoad
{
    [super viewDidLoad];
    originalPass.clearButtonMode=UITextFieldViewModeWhileEditing;
    originalPass.delegate = self;
    originalPass.secureTextEntry=YES;
    
    firstPass.clearButtonMode=UITextFieldViewModeWhileEditing;
    firstPass.delegate = self;
    firstPass.secureTextEntry=YES;
    
    secondPass.clearButtonMode=UITextFieldViewModeWhileEditing;
    secondPass.delegate = self;
    [originalPass becomeFirstResponder];
    secondPass.secureTextEntry=YES;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)returnAction{
    [self popVC];
}
-(void)submitAction{
    
    if ( originalPass.text.length<6||originalPass.text.length>16)
    {
        originalLabel.text=passwordRules;
        return;
    }else
    {
        originalLabel.text=nil;
    }
    
    if (firstPass.text.length<6||firstPass.text.length>16)
    {
        firstLabel.text=passwordRules;
        return;
    }else
    {
        firstLabel.text=nil;
    }
    
    if (![secondPass.text isEqualToString:firstPass.text])
    {
        secondLabel.text=passwordAgainRules;
        return;
    }else
    {
        secondLabel.text=nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:firstPass.text forKey:@"password"];
    [dic setValue:originalPass.text forKey:@"oldPassword"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
    [self showHudInBottom:@"提交中。"  autoHidden : NO];
    [self getDate:URL_UpdatePassword andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeHUD];
        int code =[[responseObject objectForKey:@"code"] intValue];
        if ( code == 0) {
            [self showHudInBottom:@"修改成功" autoHidden:YES];
        }else if(code == 1011){
            originalLabel.text = @"原密码错误";
        }else if(code == 1000){
            [self removeHUD];
            [self showHudInBottom:@"修改失败" autoHidden:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"修改失败" autoHidden:YES];
        //            [self popVC];
    }];
    
    
    
    
}

// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==90002)
    {
        if ( originalPass.text.length<6||originalPass.text.length>16)
        {
            originalLabel.text=passwordRules;
            return NO;
        }else
        {
            originalLabel.text=nil;
        }
        [firstPass becomeFirstResponder];
    }else if (textField.tag==90003)
    {
        if (firstPass.text.length<6||firstPass.text.length>16)
        {
            firstLabel.text=passwordRules;
            return NO;
        }else
        {
            firstLabel.text=nil;
        }
        [secondPass becomeFirstResponder];
    }else if (textField.tag==90004)
    {
        if (![secondPass.text isEqualToString:secondPass.text])
        {
            secondLabel.text=passwordAgainRules;
            return NO;
        }else
        {
            secondLabel.text=nil;
        }
        
        [self submitAction];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==90002)
    {
        if ( originalPass.text.length<6||originalPass.text.length>16)
        {
            originalLabel.text=passwordRules;
            return NO;
        }else
        {
            originalLabel.text=nil;
        }
    }else if (textField.tag==90003)
    {
        if (firstPass.text.length<6||firstPass.text.length>16)
        {
            firstLabel.text=passwordRules;
            return NO;
        }else
        {
            firstLabel.text=nil;
        }
    }else if (textField.tag==90004)
    {
        if (![secondPass.text isEqualToString:firstPass.text])
        {
            secondLabel.text=passwordAgainRules;
            return NO;
        }else
        {
            secondLabel.text=nil;
        }
        
    }
    
    
    return YES;
}
-(void)popVC {
    //    返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
