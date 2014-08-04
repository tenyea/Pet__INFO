//
//  PetHospitalDetailViewController.h
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
#import "PetHosDetailView.h"
@class HospitalModel;
@interface PetHospitalDetailViewController : TenyeaBaseViewController<PetHosDetailViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    HospitalModel *model;
}

-(id)initWithHospitail:(HospitalModel *)hmodel;


@property (strong,nonatomic) HospitalModel *model;
@end
