//
//  MyViewCell.m
//  宠信
//
//  Created by tenyea on 14-7-31.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyViewCell.h"
@implementation MyViewCell

-(id)initWithEditStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IndexPath :(NSIndexPath *)indexPath {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeButton) name:NC_removeButton object:nil];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
        imageView.tag = 100;
        [self.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
        label.tag = 101;
        label.font = [UIFont boldSystemFontOfSize: 13];
        label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
        [self.contentView addSubview:label];
        self.isEdited = YES;
        _indexPath = indexPath;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeButton) name:NC_removeButton object:nil];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 40, 30)];
        imageView.tag = 100;
        [self.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
        label.tag = 101;
        label.font = [UIFont boldSystemFontOfSize: 13];
        label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
        [self.contentView addSubview:label];
        self.isEdited = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
-(void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    if (_isEdited) {
        frame.size.width = ScreenWidth - 10*2 + 60;
    }else{
        frame.size.width =ScreenWidth - 2 * 10;
    }
    [super setFrame:frame];
}

-(void)setIsEdited:(BOOL)isEdited{
    _isEdited = isEdited;
    
    if (_isEdited) {
        if (!_swipeLeftGesture) {
            _swipeLeftGesture =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(deleteCell:)];
            _swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;//不设置黑夜是右
        }
        if (!_deleteButton) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake( ScreenWidth - 20, -2, 10, self.bounds.size.height)];
            view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
//            view.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:view];
            
            
            _deleteButton = [[ UIButton alloc]initWithFrame:CGRectMake( ScreenWidth - 20, 0, 60, self.bounds.size.height)];
            [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            _deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            _deleteButton.backgroundColor = [UIColor redColor];
            [_deleteButton addTarget: self  action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self addSubview:_deleteButton];
            _deleteButton.hidden = YES;
        }
        
        if (!_oneGesture) {
            _oneGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnAction:)];
            _oneGesture.numberOfTapsRequired = 1;
        }
        [self addGestureRecognizer:_swipeLeftGesture];
    }
}

-(void)deleteCell:(UISwipeGestureRecognizer *)swipeLeftGesture{
    if (swipeLeftGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_removeButton object:nil userInfo:nil];
//        [self addSubview:_deleteButton];
        _deleteButton.hidden = NO;
        self.width = ScreenWidth - 10*2 + 60;
        [UIView animateWithDuration:.3 animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, -60, 0);
        }];
        [self removeGestureRecognizer:_swipeLeftGesture];
        [self addGestureRecognizer:_oneGesture];
    }
}
-(void)returnAction:(UITapGestureRecognizer *)oneGesture{
    [self removeButton];
}

-(void)removeButton {
    if (_isEdited) {
        [self addGestureRecognizer:_swipeLeftGesture];
        [self removeGestureRecognizer:_oneGesture];
//        [_deleteButton removeFromSuperview];
        _deleteButton.hidden = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
        self.width =ScreenWidth - 10*2 ;

    }
}
-(void)deleteAction {
    
    if ([self.eventDelegate respondsToSelector:@selector(deleteAction:)]) {
        [self.eventDelegate deleteAction:_indexPath];
    }
    [self removeButton];
}

@end
