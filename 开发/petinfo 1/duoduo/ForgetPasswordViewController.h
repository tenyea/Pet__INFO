//
//  ForgetPasswordViewController.h
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface ForgetPasswordViewController : TenyeaBaseViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *userNameMes;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;

@end
