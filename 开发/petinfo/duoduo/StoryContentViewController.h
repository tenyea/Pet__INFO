//
//  StoryContentViewController.h
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//


#import "TenyeaNoBarVC.h"
/**
 *  故事页的内容页。主要显示图片和文字。有评论、喜欢、分享三个按钮
 */
@interface StoryContentViewController : TenyeaNoBarVC
@property (strong, nonatomic)  UIScrollView *backgroundScrollView;

@property (strong, nonatomic)  UIImageView *contentImageView;

@property (nonatomic,strong)NSString *petPresentation;
@property (nonatomic,strong)NSString *petImageViewURL;

/**
 *  通过
 *
 *  @param imageId     当前页面的id
 *  @param hasComments yes：用评论按钮  no：没有按钮评论
 *
 *  @return id
 */
-(id)initWithID:(NSString *)imageId hasComments:(BOOL)hasComments;
@end
