//
//  UpdatePasswordViewController.m
//  宠信
//
//  Created by tenyea on 14-7-21.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "OpenUDID.h"
#define passwordRules @"密码长度为6-16"
#define passwordAgainRules @"确认密码不正确"
@interface UpdatePasswordViewController ()
{
    NSString *_userName;
}
@end

@implementation UpdatePasswordViewController

@synthesize secondPass = secondPass,secondLabel = secondLabel;
@synthesize firstPass = firstPass ,firstLabel = firstLabel;

-(id)initWithuserName:(NSString *)userName{
    self = [super init];
    if (self) {
        _userName = userName;
    }
    return self;
}
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

-(void)submitAction{
    if([firstPass.text isEqualToString:secondPass.text])
    {
        
        if (firstPass.text.length<6||firstPass.text.length>16)
        {
            firstLabel.text=passwordRules;
            return ;
        }else
        {
            firstLabel.text=nil;
        }
        if (![secondPass.text isEqualToString:secondPass.text])
        {
            secondLabel.text=passwordAgainRules;
            return ;
        }else
        {
            secondLabel.text=nil;
        }

        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:firstPass.text forKey:@"password"];
        [dic setObject:_userName forKey:@"username"];
        [dic setObject:[OpenUDID value] forKey:@"deviceId"];
        [self getDate:URL_updatePassWoreBySecurity andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            int code = [[responseObject objectForKey:@"code"]intValue];
            if (code == 0 ) {
                [self showHudInBottom:@"修改成功"  autoHidden : YES];
                [self performSelector:@selector(popVC) withObject:nil afterDelay:1];
            }else if(code == 1001){
                self.bgStr = Tenyea_str_load_error;
                self.navigationItem.rightBarButtonItem = nil;
            }else if(code == 1002){
                self.bgStr = Tenyea_str_userNameIsNo;
                self.navigationItem.rightBarButtonItem = nil;
            }else if(code == 1006){
                self.bgStr = @"密码长度不正确";
                self.navigationItem.rightBarButtonItem= nil;
            }else if(code == 1015) {
                self.navigationItem.rightBarButtonItem = nil;
                self.bgStr = @"验证码已失效,请返回重试";
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _po([error localizedDescription]);
//            [self popVC];
            self.bgStr = Tenyea_str_load_error;
        }];
        
        
    }else{
        _po(@"确认密码不正确");
        secondLabel.text=passwordAgainRules;
    }
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (firstPass.text.length<6||firstPass.text.length>16)
    {
        firstLabel.text=passwordRules;
        return NO;
    }else
    {
        firstLabel.text=nil;
    }
    if (![secondPass.text isEqualToString:secondPass.text])
    {
        secondLabel.text=passwordAgainRules;
        return NO;
    }else
    {
        secondLabel.text=nil;
    }
    

    return YES;
}
// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==90003)
    {
        if (firstPass.text.length<6||firstPass.text.length>16)
        {
            firstLabel.text=passwordRules;
            return  NO;
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

-(void)popVC {
    //    返回上一级菜单
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
