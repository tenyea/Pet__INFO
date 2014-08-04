//
//  MyViewCell.h
//  宠信
//
//  Created by tenyea on 14-7-31.
//  Copyright (c) 2014年 zzw. All rights reserved.
//
@protocol EditDelegate <NSObject>

-(void)deleteAction :(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>

@interface MyViewCell : UITableViewCell{
    UISwipeGestureRecognizer *_swipeLeftGesture;
    UITapGestureRecognizer *_oneGesture;
    UIButton *_deleteButton;
    NSIndexPath *_indexPath;
}
@property (nonatomic,assign) BOOL isEdited; //用于增加左滑删除手势


@property (nonatomic,assign) id<EditDelegate> eventDelegate;
-(id)initWithEditStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IndexPath :(NSIndexPath *)indexPath;
@end
