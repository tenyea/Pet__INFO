//
//  UserPetInfoCell.m
//  宠信
//
//  Created by tenyea on 14-9-9.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "UserPetInfoCell.h"
#import "UIButton+AFNetworking.h"
@implementation UserPetInfoCell

-(void)setDic:(NSDictionary *)dic{
    if (_dic != dic) {
        _dic = dic;
//        头像
//        [_petImageButton setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"petHeadImage"]] forState:UIControlStateNormal];
        [_petImageButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[_dic objectForKey:@"petHeadImage"]]];
//        昵称
        _petNameLabel.text = [_dic objectForKey:@"petName"];
//        种类
//        @"狗狗",@"猫猫",@"小宠",@"水族",@"其他"
        switch ([[_dic objectForKey:@"petKind"] intValue]) {
            case 0:
                _petKindLabel.text = @"(宠物狗)";
                break;
            case 1:
                _petKindLabel.text = @"(宠物猫)";
                break;
            case 2:
                _petKindLabel.text = @"(小型宠)";
                break;
            case 3:
                _petKindLabel.text = @"(水族)";
                break;
            case 4:
                _petKindLabel.text = @"(其他)";
                break;
            default:
                break;
        }
//        年龄
        _petAgeLabel.text = [[_dic objectForKey:@"petBirthday"] isEqualToString:@"" ]?@"无":[_dic objectForKey:@"petBirthday"] ;
//        性别
        _petSexLabel.text = [[_dic objectForKey:@"petSex"] intValue] == 0 ? @"公":@"母";
//        品种
        _petVarietyLabel.text = [[_dic objectForKey:@"petVariety"] isEqualToString:@""]?@"无":[_dic objectForKey:@"petVariety"];
    }
}

- (IBAction)petInfoAction:(id)sender {
    
}
@end
