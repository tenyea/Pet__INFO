//
//  PetHosContentViewController.m
//  宠信
//
//  Created by tenyea on 14-7-23.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetHosContentViewController.h"
#import "UIImageView+AFNetworking.h"
@interface PetHosContentViewController ()
{
    NSString *_key;
    float heigh ;
    UIScrollView *scView;
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
    heigh = 0;
    
    NSDictionary *dic = @{_key: _hosId};
    [self getDate:_url  andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
            //            防止table便宜
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.view addSubview:view];
            scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
            [self.view addSubview:scView];
            
            if ([_key isEqualToString:@"hosInfoListId"]) {
                NSArray *arr  = [responseObject objectForKey:@"hosInfo"];
                if (arr.count > 0 ) {
                    for (NSDictionary *dic  in arr) {
                        [self outPutViews:dic];
                    }
                }else{
                    self.bgStr = Tenyea_str_load_error;

                }
            }else{
                NSArray *arr  = [responseObject objectForKey:@"hosDes"];
                if (arr.count > 0 ) {
                    for (NSDictionary *dic  in arr) {
                        [self outPutViews:dic];
                    }
                }else {
                    self.bgStr = Tenyea_str_load_error;

                }
            }
            if (heigh > ScreenHeight) {
                scView.contentSize = CGSizeMake(ScreenWidth , heigh);
            }
            
            
        }else if ([[responseObject objectForKey:@"code"] intValue] == 1001){
            self.bgStr = Tenyea_str_load_error;

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        self.bgStr = Tenyea_str_load_error;
        return ;
    }];
}

-(void)outPutViews :(NSDictionary *)dic {
    //            有图片
    if ([dic objectForKey:@"hosInfoImg"]) {
        UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, heigh, ScreenWidth - 80 *2 , 90)];
        [topImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"hosInfoImg"]]];
        heigh += 90 ;
        [scView addSubview:topImageView];
    }
    if ([dic objectForKey:@"hosInfoText"]) {
        UITextView *text = [[UITextView alloc]initWithFrame: CGRectMake(0, heigh, ScreenWidth, 0)];
        text.userInteractionEnabled = NO;
        text.text = [dic objectForKey:@"hosInfoText"];
        [text sizeToFit];
        heigh += text.height;
        [scView addSubview:text];
    }

}

@end
