//
//  ShowPetCell.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ShowPetCell.h"
#import "UIButton+AFNetworking.h"
#import "StoryContentViewController.h"
@implementation ShowPetCell
- (void)awakeFromNib
{
    [super awakeFromNib];
   // [self _init];
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}
-(void)_initView{
    for (int i = 0 ; i < 3;  i ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 + i *ScreenWidth/ 3, 0, 105, 88)];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UIView *bgView = [[UIView alloc]initWithFrame:button.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.top = 58;
        bgView.height = 30;
        bgView.alpha = .7;
        bgView.tag = 1000 + i;
        [self.contentView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"story_red_heart.png"]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 7, 40, 21)];
        label.font = FONT(14);
        label.textColor = [UIColor grayColor];
        label.tag = 10 + i;
        [bgView addSubview:label];
        
    }
    for (int i = 0 ; i < 2;  i ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 + i * 161 , 89, 159, 100)];
        button.tag = 103 + i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UIView *bgView = [[UIView alloc]initWithFrame:button.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.top = 159;
        bgView.height = 30;
        bgView.alpha = .7;
        bgView.tag = 1003 + i;
        [self.contentView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"story_red_heart.png"]];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(115, 7, 40, 21)];
        label.font = FONT(14);
        label.textColor = [UIColor whiteColor];
        label.tag = 13 + i;
        [bgView addSubview:label];
        
    }
    
}
-(void)setDataArr:(NSArray *)dataArr{
    if (_dataArr != dataArr) {
        _dataArr = dataArr;
//        隐藏
        for (int i = 4; i > _dataArr.count -1 ; i -- ) {
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, 100 + i );
            button.hidden = YES;
            UIView *bgView = (UIView *)VIEWWITHTAG(self.contentView, 1000 + i );
            bgView.hidden = YES;
        }
//        显示数据
        for (int i = 0 ; i < _dataArr.count; i ++ ) {
            UIButton *button = (UIButton *)VIEWWITHTAG(self.contentView, 100 + i );
            button.hidden = NO;
            UIView *bgView = (UIView *)VIEWWITHTAG(self.contentView, 1000 + i );
            bgView.hidden = NO;
            NSDictionary *dic = _dataArr[i];
//            [button setImageWithURL:[dic objectForKey:@"petPhotoImgMax"] forState:UIControlStateNormal];
            [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[dic objectForKey:@"petPhotoImgMax"]]];
            UILabel *label = (UILabel *)VIEWWITHTAG(bgView, 10 + i );
            label.text = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"petPhotoGood"] intValue]];
        }
 
    }
}

-(void)selectAction:(UIButton *)button{
    int tag = button.tag -100 ;

    NSDictionary *dic = _dataArr[tag];
    NSString *petPhotoId =[dic objectForKey:@"petPhotoId"];

    if ([self.eventDelegate respondsToSelector:@selector(pushVC:)]) {
        [self.eventDelegate pushVC:petPhotoId];
    }
}
@end
