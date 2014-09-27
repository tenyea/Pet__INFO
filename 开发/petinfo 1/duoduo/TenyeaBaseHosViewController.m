//
//  TenyeaBaseHosViewController.m
//  宠信
//
//  Created by tenyea on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseHosViewController.h"

@interface TenyeaBaseHosViewController ()

@end

@implementation TenyeaBaseHosViewController

-(id)initWithHosId:(NSString *)HosId{
    self = [super init];
    if (self) {
        self.HosId = HosId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
