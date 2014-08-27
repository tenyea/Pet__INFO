//
//  LoginViewController.m
//  宠信
//
//  Created by tenyea on 14-7-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
#import "OpenUDID.h"
#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "sys/utsname.h"

#define parametersLost @"请输入完整信息"
#define wrongInformation @"用户名或密码错误"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTF;
@synthesize passwordTF;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
        self.title=@"登录";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [userNameTF becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
    passwordTF.delegate=self;
    userNameTF.delegate=self;
    userNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordTF.secureTextEntry=YES;
}


// 键盘下一步，返回事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==123)
    {
        
        [userNameTF resignFirstResponder];
        [passwordTF becomeFirstResponder];
        
        return YES;
        
    }else if(textField.tag==124)
    {
        [userNameTF resignFirstResponder];
        [passwordTF resignFirstResponder];
        return YES;
    }else
    {
        return NO;
    }
    
}


// 登录失败取消HUD
-(void)timerFiredFailure:(NSTimer *)timer{
    [hudLabel removeFromSuperview];
    hudLabel = nil;
}

-(void)showHUDinView:(NSString *)title{
    if (!hudLabel) {
        hudLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 120)/2, (ScreenHeight - 100)/2 -100, 120, 20)];
        hudLabel.backgroundColor = [UIColor grayColor];
        hudLabel.textAlignment = NSTextAlignmentCenter;
        hudLabel.textColor = [UIColor whiteColor];
        hudLabel.font = [UIFont boldSystemFontOfSize:14];
        hudLabel.hidden = YES;
        [self.view addSubview:hudLabel];
    }
    hudLabel.text = title;
    hudLabel.hidden = NO;
}

- (IBAction)loginBtnAction:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:userNameTF.text forKey:@"username"];
    [dic setObject:passwordTF.text forKey:@"password"];
    [dic setObject:[OpenUDID value] forKey:@"deviceId"];
    NSDictionary *dicLocationnow =  [[NSUserDefaults standardUserDefaults]dictionaryForKey:UD_Locationnow_DIC];
    if (dicLocationnow) {
        [dic setObject:[dicLocationnow objectForKey:@"longitude"]  forKey:@"longitude"];
        [dic setObject:[dicLocationnow objectForKey:@"latitude"] forKey:@"latitude"];
    }else{
        [dic setObject:@"0"  forKey:@"longitude"];
        [dic setObject:@"0" forKey:@"latitude"];

    }
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    [dic setObject:deviceString forKey:@"device"];
    [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"system"];
    [dic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"version"];
    [dic setObject:[NSString stringWithFormat:@"%f*%f",ScreenWidth,ScreenHeight] forKey:@"dpi"];
    [dic setObject:[Network  getConnectionAvailable] forKey:@"gprs"];
    [dic setObject:@"0" forKey:@"type"];

    [self getDate:URL_Login andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        NSLog(@"%@",code);
        NSString *loginMessage;
        int a = [code intValue];
        if(a==0)
        {
            NSDictionary *userDic = [responseObject objectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults]setObject:userDic forKey:UD_userInfo_DIC];
            [[NSUserDefaults standardUserDefaults]setObject: [userDic objectForKey:@"userId"] forKey:UD_userID_Str];
            [[NSUserDefaults standardUserDefaults]setObject: [userDic objectForKey:@"userNickname"] forKey:UD_userName_Str];
            [[NSUserDefaults standardUserDefaults]setObject: [responseObject objectForKey:@"pet"] forKey:UD_pet_Array];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"登录成功");
        }else if(a==1001)
        {
            loginMessage = parametersLost;
            [self showHUDinView:loginMessage];
            NSLog(@"请输入完整信息");
            NSTimer *connectionTimer;  //timer对象
            connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFiredFailure:) userInfo:nil repeats:NO];
        }else if (a==1002)
        {
            loginMessage=wrongInformation;
            [self showHUDinView:loginMessage];
            NSLog(@"用户名或密码错误");
            NSTimer *connectionTimer;  //timer对象
            connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFiredFailure:) userInfo:nil repeats:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [userNameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    
}

- (IBAction)forgetPasswordAction:(id)sender {
    [self.navigationController pushViewController:[[ForgetPasswordViewController alloc] init] animated:YES];
}
@end
