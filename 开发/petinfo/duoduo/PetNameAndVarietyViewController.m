//
//  PetNameAndVarietyViewController.m
//  宠信
//
//  Created by tenyea on 14-7-16.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetNameAndVarietyViewController.h"

@interface PetNameAndVarietyViewController ()

{
    NSString *_keyName;
    NSString *_content;
    NSString *_userDefaults_name;
}
@property (strong, nonatomic) IBOutlet UITextField *textField;


@end

@implementation PetNameAndVarietyViewController
-(id)initWithType:(int)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_type==1) {
        self.title = @"品种";
        _keyName = @"petVariety";
        _userDefaults_name = UD_petInfo_temp_PetModel;
    }else{
        self.title = @"昵称";
        if (_type == 0) {//type = 0
            _keyName = @"petName";
            _userDefaults_name = UD_petInfo_temp_PetModel;
        }else {
            _keyName = @"userNickname";
            _userDefaults_name = UD_userInfo_temp_DIC;
        }

    }
    [_textField becomeFirstResponder];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    NSString *str =[[[NSUserDefaults standardUserDefaults]dictionaryForKey:_userDefaults_name] objectForKey:_keyName];
    _textField.text = str;
    _content = str;
    
}

-(void)returnAction{
    [self popVC];
}
-(void)submitAction{
    [self popVC];
}

-(void)popVC {
    _content = _textField.text;

    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:_userDefaults_name ];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [muDic setValue:_content forKey:_keyName];
    [[NSUserDefaults standardUserDefaults]setValue:muDic forKeyPath:_userDefaults_name];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //    返回上一级菜单
    [self.navigationController popViewControllerAnimated:YES];
    
}

//点击done按钮事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self popVC];
    
    return YES;
}
@end
