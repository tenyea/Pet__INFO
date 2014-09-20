//
//  CustomView.m
//  宠信
//
//  Created by tenyea on 14-8-19.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "CustomView.h"
#import "UserInfoDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation CustomView

- (id)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction:)];
        [self addGestureRecognizer:tapGeture];
    }
    return self;
}
-(void)awakeFromNib{
    UITapGestureRecognizer *tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushAction:)];
    [self addGestureRecognizer:tapGeture];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 54/2;
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    if (_userInfo != userInfo) {
        self.userNickName.text = [userInfo objectForKey:@"userNickname"];
        [self.headImageView setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"userHeadMin"]]];
        _userInfo = userInfo;
    }
}


- (void)pushAction:(UITapGestureRecognizer *)sender {
    if (_userInfo) {
        [self.viewController.navigationController pushViewController:[[UserInfoDetailViewController alloc]initWithUserId:[_userInfo objectForKey:@"userId"]] animated:YES];
    }
}
@end
