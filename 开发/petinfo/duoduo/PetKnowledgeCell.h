//
//  PetKnowledgeCell.h
//  宠信
//
//  Created by tenyea on 14-8-14.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 宠物知识cell
@interface PetKnowledgeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *leftImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) NSDictionary *dic;
@end
