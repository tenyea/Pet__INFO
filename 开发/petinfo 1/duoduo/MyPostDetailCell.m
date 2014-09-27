//
//  MyPostDetailCell.m
//  宠信
//
//  Created by tenyea on 14-7-30.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyPostDetailCell.h"
#import "UIButton+AFNetworking.h"
//#import "UIButton+AFNetworking.h"
#import "DataCenter.h"
#import "UserInfoDetailViewController.h"
@implementation MyPostDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {

    }
    return self;
}

-(void)setDic:(NSDictionary *)dic {
    if (_dic != dic) {
        _dic = dic;
        [self setNeedsDisplay];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_dic) {
        return;
    }
//    回复信息
//    头像
    NSURL *url = [NSURL URLWithString:[_dic objectForKey:@"petPhotoDisUserHead"]];

//    [_userButton setImageWithURL:url forState:UIControlStateNormal];
//    [_userButton setImageWithURL:url forState:UIControlStateSelected];
    [_userButton setImageForState:UIControlStateNormal withURL:url];
    [_userButton setImageForState:UIControlStateSelected withURL:url];
    
//    [_userButton setImageForState:UIControlStateNormal withURL:url];
//    标题
    _userNameLabel.text = [_dic objectForKey:@"petPhotoDisUserName"];
//    楼号
    _buildingNoLabel.text = [NSString stringWithFormat:@"%@楼", [_dic objectForKey:@"petPhotoDisFloor"]];
    _timeLabel.text = [DataCenter intervalSinceNow:[_dic objectForKey:@"petPhotoDisTime"]];
    
//    回复内容
    NSString *str = [_dic objectForKey:@"petPhotoDisText"];
    _contentTextView.text = str;
    _contentTextView.delegate = self;

    CGSize size = [str  boundingRectWithSize:CGSizeMake(180  , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
    _contentTextView.height = size.height+20;
//    回复的内容
    if ([[_dic objectForKey:@"huifuFloor"] intValue ] != 0 ) {
        _returnContentView.hidden = NO;
        _returnContentView.top = _contentTextView.bottom ;
//        名字
        _reUserNameLabel.text = [_dic objectForKey:@"huifuUserName"];
//        时间
        _reTimeLabel.text = [DataCenter intervalSinceNow:[_dic objectForKey:@"huifuTime"]];
        [_reTimeLabel sizeToFit];
//        楼号
        _reBuildingNoLabel.text = [NSString stringWithFormat:@"%@楼", [_dic objectForKey:@"huifuFloor"]];
        [_reBuildingNoLabel sizeToFit];
        
        _reBuildingNoLabel.right = _returnContentView.width;
        _reTimeLabel.right = _reBuildingNoLabel.left - 3;
        
//        内容
        _reContentTextView.text = [_dic objectForKey:@"huifuText"];
        _reContentTextView.delegate = self;
        _reContentTextView.backgroundColor = [UIColor colorWithRed:1 green:0.96 blue:0.95 alpha:1];
        CGSize reSize = [[_dic objectForKey:@"huifuText"]  boundingRectWithSize:CGSizeMake(218  , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
        _reContentTextView.height = reSize.height + 20;
        
        _returnContentView.height = reSize.height + 20 + 30;
        _returnView.top = _returnContentView.bottom;

    }else{
        _returnView.top = _contentTextView.bottom - 20 ;

    }
    
//  调整位置
    _returnView.right = ScreenWidth ;
    [self.contentView bringSubviewToFront:_returnView];
}
+(float) getCellHeight : (NSDictionary *)dic{
    float height = 0;
    if (dic) {
        NSString *content = [dic objectForKey:@"petPhotoDisText"];
        CGSize size = [content  boundingRectWithSize:CGSizeMake(180 , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
        
        height = size.height + 20 + 30 + 40 + 4;//回复高度+15  + 回复的上高 + 按钮高 + 留白
        if ([[dic objectForKey:@"huifuFloor"] intValue ] != 0) {
            CGSize reSize = [[dic objectForKey:@"huifuText"]  boundingRectWithSize:CGSizeMake(218  , 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: FONT(12)} context:nil].size;
            height += reSize.height + 20 + 30 ;//回复高度+15  + 回复的上高

        }else {
            height -= 20;
        }
        return height;
    }else{
        return height;
    }
}

- (IBAction)userInfoAction:(id)sender {
    NSString *userId = [_dic objectForKey:@"petPhotoDisUserId"];
    [self.viewController.navigationController pushViewController:[[UserInfoDetailViewController alloc] initWithUserId:userId] animated:YES];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
- (IBAction)returnAction:(UIButton *)sender {
    NSString *petPhotoDisId = [_dic objectForKey:@"petPhotoDisId"];
    NSString *userName = [_dic objectForKey:@"petPhotoDisUserName"];
    if ([self.eventDelegate respondsToSelector:@selector(reAction:userName:)]) {
        [self.eventDelegate reAction:petPhotoDisId userName:userName];
    }
}
@end
