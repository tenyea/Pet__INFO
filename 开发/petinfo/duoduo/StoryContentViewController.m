//
//  StoryContentViewController.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryContentViewController.h"
#import "UIImageView+WebCache.h"
@interface StoryContentViewController ()

@end

@implementation StoryContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _backgroundScrollView.contentSize=CGSizeMake(320, 20000);
    NSURL *url = [NSURL URLWithString:_petImageViewURL];
     [_contentImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
    _contentLabel.text=_petPresentation;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
