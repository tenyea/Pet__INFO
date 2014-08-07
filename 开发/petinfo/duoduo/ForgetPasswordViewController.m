//
//  ForgetPasswordViewController.m
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "SecurityViewController.h"
@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.emalLabel becomeFirstResponder];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)submitAction{
    
    if (![self validateEmail:_emalLabel.text]) {
        self.emailMes.text = @"邮箱格式不正确";
        return;
    }else{
        self.emailMes.text = nil;
    }
    
    [self.navigationController pushViewController:[[SecurityViewController alloc] initWithEmail:_emalLabel.text]animated:YES];
}

// 邮箱格式判断
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self submitAction];
    
    return YES;
}
@end
