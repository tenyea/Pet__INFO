//
//  DoctorDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-8-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AskOnlineViewController.h"
@interface DoctorDetailViewController ()
{
    NSString *docId;
    NSString *docName;
}
@end

@implementation DoctorDetailViewController
-(id)initWithDoctorId:(NSString *)doctorId{
    self = [super init];
    if (self) {
        docId = doctorId;
    }
    return self;
}
-(void)askAction {
     [self.navigationController pushViewController:[[AskOnlineViewController alloc]initWithDoctorId:docId andDocName:docName] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bgStr = @"加载中";
    [self getDate:URL_getDoctorInfo andParams:@{@"docId": docId} andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue ] == 0 ) {
            self.bgStr = @"";
            float heigh = 0;
            UIScrollView *bgScView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [self.view addSubview:bgScView];
            NSDictionary *dic = [responseObject objectForKey:@"doc"];
            if ([dic objectForKey:@"docPhotoMax"]) {
                UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 200 + 44)];
                [headImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"docPhotoMax"]]];
                headImageView.contentMode = UIViewContentModeCenter;
                [bgScView addSubview:headImageView];
                heigh += 200 + 44+ 20;
            }
            
            if ([dic objectForKey:@"docName"]) {
                docName = [dic objectForKey:@"docName"];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, heigh, ScreenWidth - 20, 15)];
                label.text = [NSString stringWithFormat:@"姓名:%@",[dic objectForKey:@"docName"] ];
                label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
                label.font = FONT(15);
                [label sizeToFit];
                [bgScView addSubview:label];
                
                heigh += label.height;
            }
            
            if ([dic objectForKey:@"docTitle"]) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, heigh, ScreenWidth - 20, 15)];
                label.text = [NSString stringWithFormat:@"职务:%@",[dic objectForKey:@"docTitle"] ];
                label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
                label.font = FONT(15);
                [label sizeToFit];
                [bgScView addSubview:label];
                
                heigh +=label.height;
            }
            
            if ([dic objectForKey:@"docSpec"]) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, heigh, ScreenWidth - 20, 15)];
                label.text = [NSString stringWithFormat:@"专长:%@",[dic objectForKey:@"docSpec"] ];
                label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
                label.font = FONT(15);
                [label sizeToFit];
                [bgScView addSubview:label];
                
                heigh +=label.height;
            }
            
            
            if ([dic objectForKey:@"docDes"]) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, heigh, ScreenWidth - 20, 300)];
                label.text = [NSString stringWithFormat:@"简介:%@",[dic objectForKey:@"docDes"] ];
                label.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
                label.font = FONT(15);
                [label sizeToFit];
                [bgScView addSubview:label];
                
                heigh += label.height;
            }
            
            
            
            if ( heigh > ScreenHeight ) {
                bgScView.contentSize = CGSizeMake(ScreenWidth, heigh);
            }
            
            
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button addTarget:self action:@selector(askAction) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"咨询" forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = item;
            
        }else{
            self.bgStr = Tenyea_str_load_error;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.bgStr = Tenyea_str_load_error;
    }];
}


@end
