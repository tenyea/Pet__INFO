//
//  SecurityViewController.m
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "SecurityViewController.h"
#import "UpdatePasswordViewController.h"
#import "OpenUDID.h"
#import "DataCenter.h"
@interface SecurityViewController ()
{
    NSString *_userName;
    NSDate *_endDate;
    int _securityCode ;//验证码
    NSTimer *_timer;
}
@end

@implementation SecurityViewController

#define code_timeOut @"验证码超时了,请重试"
#define time_out 60*5
@synthesize securityText = securityText,emailLabel = emailLabel,securityLabel= securityLabel;
-(id)initWithUserName:(NSString *)userName{
    self = [super init];
    if (self) {
        _userName = userName;
        _securityCode = 0;
    }
    return self;
}

- (IBAction)reloadAction:(id)sender {
    [self loadDate];
    _infoLabel.text =@"验证码重新发送至";//验证码未失效

}

-(void)loadDate {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:3];
    [params setObject:_userName forKey:@"username"];
    [params setObject:[OpenUDID value] forKey:@"deviceId"];
    [self getDate:URL_getSecurity andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int code = [[responseObject objectForKey:@"code"] intValue] ;
        if ( code == 0||code == 1014 ) {
            _infoLabel.text = @"我们已发送验证码至";
            emailLabel.text = [self encryptEmail:[responseObject objectForKey:@"email"]];
            _securityCode =  [[responseObject objectForKey:@"codeNum"] intValue];
            NSString *time = [responseObject objectForKey:@"time"];
            _endDate = [NSDate dateWithTimeInterval:time_out sinceDate:[DataCenter StringTODate:time]];
            
            securityText.clearButtonMode =UITextFieldViewModeWhileEditing;
            [securityText becomeFirstResponder];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [button setTitle:@"继续" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        }else if(code == 1001){
            self.bgStr = Tenyea_str_load_error;
        }else if(code == 1012){//用户名不存在
            self.bgStr = Tenyea_str_userNameIsNo;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDate];
}
//倒计时
-(void)countdown{
    if ([[NSDate date] compare:_endDate] == NSOrderedAscending ) {
        int d = [ _endDate timeIntervalSinceNow] ;
        securityText.placeholder = [NSString stringWithFormat:@"    请输入验证码(%d秒)",d];
    }else{
        [_timer invalidate];
        securityText.placeholder = code_timeOut;

    }
    
}
//提交
-(void)submitAction{
    NSString *str = securityText.text;
    if ([str intValue] == _securityCode) {
        
        securityLabel.text = nil;
        if ([[NSDate date] compare:_endDate] == NSOrderedAscending ) {
            [self.navigationController pushViewController:[[UpdatePasswordViewController alloc]initWithuserName:_userName] animated:YES];
        }else{
            securityLabel.text = code_timeOut;
        }
        
    }else{
        securityLabel.text = @"验证码错误";
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self submitAction];
    return YES;
}

-(NSString *)encryptEmail:(NSString *)email{
    NSArray *arr = [email componentsSeparatedByString:@"@"];
    NSString *newEmail = arr[0];
    if (newEmail.length > 3) {
        NSString *str = [newEmail stringByReplacingCharactersInRange:NSMakeRange(2, newEmail.length - 3) withString:@"******"];

        return [NSString stringWithFormat:@"%@@%@",str,arr[1]];
    }else if (newEmail.length > 1 &&newEmail.length < 4) {
        NSString *str = [newEmail stringByReplacingCharactersInRange:NSMakeRange(1, newEmail.length - 1) withString:@"******"];
        
        return [NSString stringWithFormat:@"%@@%@",str,arr[1]];
    }else{
        return email;
    }
}

@end
