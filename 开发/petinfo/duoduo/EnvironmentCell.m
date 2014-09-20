//
//  EnvironmentCell.m
//  宠信
//
//  Created by tenyea on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "EnvironmentCell.h"
#import "UIImageView+AFNetworking.h"
#import "PetHosContentViewController.h"
@implementation EnvironmentCell

- (void)awakeFromNib
{
    _leftImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *lefttapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftAction:)];
    [_leftImageView addGestureRecognizer:lefttapGeture];
    
    _rightImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *righttapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction:)];
    [_rightImageView addGestureRecognizer:righttapGeture];
}




-(void)setArr:(NSArray *)arr {
    if(_arr != arr){
        _arr = arr;
        if ([arr count ] == 2) {
            _leftDic = arr[0];
            _rightDic = arr[1];
        }else if ([arr count] == 1){
            _leftDic = arr[0];
        }
        [self setNeedsDisplay];

    }
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_leftImageView setImageWithURL:[NSURL URLWithString: [_leftDic objectForKey:@"hosInfoPic"]]];
    _leftLabel.text = [_leftDic objectForKey:@"hosInfoTitle"];
    if (_rightDic ) {
        [_rightImageView setImageWithURL:[NSURL URLWithString: [_rightDic objectForKey:@"hosInfoPic"]]];
        _rightLabel.text = [_rightDic objectForKey:@"hosInfoTitle"];
    }
}

- (void)leftAction:(UITapGestureRecognizer *)sender {
    _po(@"123");
    if (_leftDic) {
        [self.viewController.navigationController pushViewController:[[PetHosContentViewController alloc]initWithUrl:URL_getHosInfo id:[_leftDic objectForKey:@"hosInfoListId"]] animated:YES];
    }
}

- (void)rightAction:(UITapGestureRecognizer *)sender {
    _po(@"456");
    if (_rightDic) {
        [self.viewController.navigationController pushViewController:[[PetHosContentViewController alloc]initWithUrl:URL_getHosInfo id:[_rightDic objectForKey:@"hosInfoListId"]] animated:YES];
    }
    
}


@end
