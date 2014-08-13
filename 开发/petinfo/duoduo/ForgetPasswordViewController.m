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
    
    [self.userNameTextField becomeFirstResponder];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)submitAction{
    
    if (self.userNameTextField.text.length < 4 ||self.userNameTextField.text.length > 10) {
        self.userNameMes.text = @"用户名长度不正确";
        return;
    }else{
        self.userNameMes.text = nil;
    }
    
    [self.navigationController pushViewController:[[SecurityViewController alloc] initWithUserName:_userNameTextField.text]animated:YES];
}


// 键盘下一步，返回操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self submitAction];
    
    return YES;
}
@end
