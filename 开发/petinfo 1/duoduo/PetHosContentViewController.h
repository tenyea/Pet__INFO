//
//  PetHosContentViewController.h
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface PetHosContentViewController : TenyeaBaseViewController

-(id)initWithUrl:(NSString *)url id:(NSString *)hospId;
-(id)initWithUrl:(NSString *)url id:(NSString *)hospId andkey :(NSString *)key;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *hosId;
@end
