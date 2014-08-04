//
//  UpdatePasswordViewController.h
//  宠信
//
//  Created by tenyea on 14-7-21.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface UpdatePasswordViewController : TenyeaBaseViewController<UITextFieldDelegate>
{
    UITextField *firstPass;
    UITextField *secondPass;
    UILabel *secondLabel;
    UILabel *firstLabel;
}
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UITextField *firstPass;
@property (strong, nonatomic) IBOutlet UITextField *secondPass;

@end
