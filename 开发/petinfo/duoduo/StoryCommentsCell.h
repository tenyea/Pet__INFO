//
//  StoryCommentsCell.h
//  宠信
//
//  Created by tenyea on 14-8-13.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  评论视图cell
 */
@interface StoryCommentsCell : UITableViewCell
{
    UILabel *_userNameLabel;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    UIView *_view;
}
@property (nonatomic,strong) NSDictionary *dic;
/**
 *  通过字符串计算高度
 *
 *  @param str 字符串
 *
 *  @return 高度
 */
+(float)getCommentHeight:(NSString *)str;
@end
