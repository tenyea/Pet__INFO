//
//  PetHosContentViewController.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetHosContentViewController.h"
#import "UIImageView+WebCache.h"
@interface PetHosContentViewController ()
{
    NSString *_key;
}
@end

@implementation PetHosContentViewController

-(id)initWithUrl:(NSString *)url id:(NSString *)hospId{
    self = [super init];
    if (self) {
        self.url = url;
        self.hosId = hospId;
        _key = @"hosInfoListId";
    }
    return self;
}

-(id)initWithUrl:(NSString *)url id:(NSString *)hospId andkey :(NSString *)key{
    self = [super init];
    if (self) {
        self.url = url;
        self.hosId = hospId;
        _key = key;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSDictionary *dic = @{_key: _hosId};
    [self getDate:_url  andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
            //            防止table便宜
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.view addSubview:view];
            UIScrollView *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [self.view addSubview:scView];
            NSDictionary *dic ;
            if ([_key isEqualToString:@"hosInfoListId"]) {
                dic = [responseObject objectForKey:@"hosInfo"][0];
            }else{
                dic = [responseObject objectForKey:@"hosDes"][0];

            }
            float heigh = 0;
//            有图片
            if ([dic objectForKey:@"hosInfoImg"]) {
                UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 0, ScreenWidth - 80 *2 , 90)];
                [topImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"hosInfoImg"]]];
                heigh += 90 ;
                [scView addSubview:topImageView];
            }
            if ([dic objectForKey:@"hosInfoText"]) {
                UITextView *text = [[UITextView alloc]initWithFrame: CGRectMake(0, heigh, ScreenWidth, 0)];
                text.text = [dic objectForKey:@"hosInfoText"];
                [text sizeToFit];
                heigh += text.height;
                [scView addSubview:text];
            }
            if (heigh > ScreenHeight) {
                scView.contentSize = CGSizeMake(ScreenWidth , heigh);
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(50, 200, ScreenWidth - 50 *2, 20);
        label.text = @"出错了。。请稍后再试";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        return ;
    }];
}


@end
