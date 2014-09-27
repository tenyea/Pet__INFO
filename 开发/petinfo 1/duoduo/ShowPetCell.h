//
//  ShowPetCell.h
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
@protocol pushVCDelegate <NSObject>

-(void)pushVC:(NSString *)petPhotoId;

@end
#import <UIKit/UIKit.h>
/**
 *  嗮萌宠视图
 */
@interface ShowPetCell : UITableViewCell
@property (strong, nonatomic) NSArray *dataArr;
@property (nonatomic, assign) id<pushVCDelegate> eventDelegate;
@end
