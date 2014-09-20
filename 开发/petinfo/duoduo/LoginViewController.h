//
//  LoginViewController.h
//  宠信
//
//  Created by tenyea on 14-7-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface LoginViewController : TenyeaBaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel *hudLabel;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)loginBtnAction:(id)sender;

- (IBAction)forgetPasswordAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end