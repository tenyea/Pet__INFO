//
//  SecurityViewController.h
//  宠信
//
//  Created by tenyea on 14-8-6.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface SecurityViewController : TenyeaBaseViewController<UITextFieldDelegate>{
    UILabel *emailLabel;
    UITextField *securityText;
    UILabel *securityLabel;
}
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *securityLabel;
@property (strong, nonatomic) IBOutlet UITextField *securityText;
-(id)initWithUserName:(NSString *)userName;
- (IBAction)reloadAction:(id)sender;


@end
