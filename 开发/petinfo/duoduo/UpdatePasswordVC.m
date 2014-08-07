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
{
    NSString *registeredMessage;
}
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
    if([firstPass.text isEqualToString:secondPass.text])
    {
        if (registeredMessage) {
            return;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:firstPass.text forKey:@"password"];
        [dic setValue:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
        [self showHudInBottom:@"提交中。"];
        [self getDate:URL_UpdatePassword andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self removeHUD];
            int code =[[responseObject objectForKey:@"code"] intValue];
            if ( code == 0) {
                [self showHudInBottom:@"修改成功"];
                [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.5];
                [self performSelector:@selector(popVC) withObject:nil afterDelay:1.5];
#warning !!!!
            }else if(code == 1001){
                originalLabel.text = @"原密码错误";
            }else if(code == 1000){
                [self removeHUD];
                [self showHudInBottom:@"修改失败"];
                [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _po([error localizedDescription]);
            [self removeHUD];
            [self showHudInBottom:@"修改失败"];
            [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.5];
//            [self popVC];
        }];
        
        
    }else{
        _po(@"确认密码不正确");
        secondLabel.text=passwordAgainRules;
    }
    
}

// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==90002)
    {
        if ( originalPass.text.length<6||originalPass.text.length>16)
        {
            registeredMessage=passwordRules;
            originalLabel.text=passwordRules;
        }else
        {
            originalLabel.text=nil;
        }
        [firstPass becomeFirstResponder];
    }else if (textField.tag==90003)
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
