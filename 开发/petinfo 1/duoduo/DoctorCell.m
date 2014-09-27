//
//  DoctorCell.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "DoctorCell.h"
#import "DoctorModel.h"
#import "AskOnlineViewController.h"
#import "UIImageView+AFNetworking.h"
@implementation DoctorCell

- (void)awakeFromNib
{

}
-(void)setModel:(DoctorModel *)model{
    if (_model != model) {
        _model = model;
        [self.headImageView setImageWithURL:[NSURL URLWithString:_model.docPhotoMin]];
        self.usernameLabel.text = _model.docName;
        self.positionLabel.text = _model.docTitle;
        self.specialLabel.text = _model.docSpec;
    }
}

- (IBAction)askAction:(id)sender {
    [self.viewController.navigationController pushViewController:[[AskOnlineViewController alloc]initWithDoctorId:_model.docId andDocName:_model.docName]  animated:YES];
}
@end
