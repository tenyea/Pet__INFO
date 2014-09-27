//
//  MyViewCell.m
//  宠信
//
//  Created by tenyea on 14-7-31.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyViewCell.h"
@implementation MyViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];

        imageView.tag = 100;
        [self.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
        label.tag = 101;
        label.font = [UIFont boldSystemFontOfSize: 13];
        label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
        [self.contentView addSubview:label];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
-(void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.width =ScreenWidth - 2 * 10;
    [super setFrame:frame];
}





@end
