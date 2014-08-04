//
//  PetNameAndVarietyViewController.h
//  宠信
//
//  Created by tenyea on 14-7-16.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface PetNameAndVarietyViewController : TenyeaBaseViewController<UITextFieldDelegate>
@property (nonatomic,assign) int type;

-(id)initWithType:(int)type; //0昵称 1种类 代表宠物 2代表用户昵称
@end
