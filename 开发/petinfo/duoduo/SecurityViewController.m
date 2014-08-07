//
//  SecurityViewController.m
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "SecurityViewController.h"
#import "UpdatePasswordViewController.h"
@interface SecurityViewController ()
{
    NSString *_email;
}
@end

@implementation SecurityViewController
@synthesize securityText = securityText,emailLabel = emailLabel,securityLabel= securityLabel;
-(id)initWithEmail:(NSString *)email{
    self = [super init];
    if (self) {
        _email = email;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    emailLabel.text = _email;
    securityText.clearButtonMode =UITextFieldViewModeWhileEditing;
    [securityText becomeFirstResponder];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"继续" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}
-(void)submitAction{
    if ([securityText.text isEqualToString:@"1234"]) {
        
        securityLabel.text = nil;
        
        [self.navigationController pushViewController:[[UpdatePasswordViewController alloc]init] animated:YES];
    }else{
        securityLabel.text = @"验证码错误";
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self submitAction];
    return YES;
}
@end
