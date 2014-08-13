//
//  StoryViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "StoryViewController.h"
#import "MJRefresh/MJRefresh.h"
#import "StoryCell.h"
#import "MoveButton.h"
#import "ShowPetCell.h"
#import "LikePetCell.h"
#import "StoryContentViewController.h"
#import "UIImageView+WebCache.h"
#define offsetY 64

@interface StoryViewController ()
{
    NSArray *_dataArray;
    UIView *_topView;
    int rowHeigh;
    NSArray *story_data;
    NSArray *story_star;
    NSArray *story_show_pet;
    NSArray *story_popularity;
}
@end

@implementation StoryViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    rowHeigh=88;
    [self _initView];
    
}
#pragma mark -
#pragma mark init
-(void)_initView{
    [self _initTOPView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces=NO;
    
    [self.view sendSubviewToBack:_tableView];
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(EditAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"story_edit.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
}

//初始化顶部4个按钮
-(void)_initTOPView{
    
    NSArray *nameArr = @[@"宠物明星",@"晒萌宠",@"人气萌宠",@"附近宠物"];
    NSArray *imageArr = @[@"story_star.png",@"story_image.png",@"story_sentiment.png",@"story_near.png"];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, -60, ScreenWidth, (nameArr.count/2)*60 )];
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake( 0 , 0, 320, 60);
    view.backgroundColor=[UIColor colorWithRed:0.95 green:0.99 blue:1 alpha:1];

    [_topView addSubview:view];
   
    _topView.backgroundColor = [UIColor colorWithRed:0.95 green:0.99 blue:1 alpha:1];
    for (int i = nameArr.count-1; i >= 0; i --) {
        MoveButton *button = [[MoveButton alloc]initWithFrame:CGRectMake(45 + i%2 *160, (i/2 )*60 +20, 70, 40) LabelText:nameArr[i] ImageView:imageArr[i]];
        button.backgroundColor = [UIColor colorWithRed:0.36 green:0.68 blue:0.89 alpha:1];
        button.tag = i +100;
        _pn(button.tag);
        [button addTarget:self action:@selector(TouchAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view insertSubview:button atIndex:NSIntegerMax-i-10];
    }
    
}

#pragma mark -
#pragma mark method
//y=-2x +3
//下排按钮
-(float)lowMovepath:(float)x{
    float result = 0.0;
    result = -2*x + 3;
    return result;
}
//上排按钮
-(float)highMovepath:(float)x{
    float result = 0.0;
    result = -1.7*x + 2.7;
    return result;
}
//顶部按钮动画
-(void)TopButtonFrameChange :(float )contentoffset_y{
  //  contentoffset_y+=offsetY;
    if (contentoffset_y> - 64 &&contentoffset_y < -4) {
        float now_offset = (64 + contentoffset_y) /60;
        for (int i = 0  ; i < 4 ; i ++ ) {
            int tag = 100 + i ;
            UIButton *button = (UIButton *)VIEWWITHTAG(self.view, tag);
            CGPoint point = button.center ;
         

            
            if(i/2 == 0){//上面两个
                point.x = (80 + 160 * (i%2) - now_offset*40 * [self highMovepath:now_offset] )  ;
                point.y = 85 + now_offset *10;
            }else {//下面俩
                point.x = 80 + 160 * (i%2) +now_offset*40 *  [self lowMovepath:now_offset];
                point.y = 155 - now_offset * 60;
            }
            button.center = point;
           
        }
        
    }else if (contentoffset_y < - 63){
        for (int i = 0  ; i < 4 ; i ++ ) {
            int tag = 100 + i ;
            MoveButton *button = (MoveButton *)VIEWWITHTAG(self.view, tag);
            button.center = CGPointMake( (i%2) * 160 +80 , (i/2) *60 +30+offsetY);
//            button.frame = CGRectMake(40 + i%2 *160, (i/2 )*60, 80, 60);
            [button beginAnimation];
           // _pn(tag);
        }
    }else if (contentoffset_y > -5){
        for (int i = 0  ; i < 4 ; i ++ ) {
            int tag = 100 + i ;
            MoveButton *button = (MoveButton *)VIEWWITHTAG(self.view, tag);
            button.center = CGPointMake(40 + (i/2) * 80 + (i%2) * 160 , 95);
//            button.frame = CGRectMake((i/2)*80 + (i%2) *160, 60, 80, 60);
            [button endAnimation];
           // _pn(tag);
        }
    }

}


#pragma mark - 
#pragma mark Action
//topview下4个按钮事件
-(void)TouchAction:(UIButton *)button {
    switch (button.tag) {
            
        case 100:
        {
            
            _po(@"111");
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:@"1" forKey:@"type"];
            

            [self getDate:URL_Story_Four_To_One andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *code =[responseObject objectForKey:@"code"];
                
                int a = [code intValue];
                if(a==0)
                {
                    story_star=[responseObject objectForKey:@"petPhotoList"];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            _po(story_star);
            rowHeigh=89;
            [_tableView reloadData];

           
        }
         break;
        case 101:
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:@"0" forKey:@"type"];

            _po(@"222");
            [self getDate:URL_Story_Four_To_One andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *code =[responseObject objectForKey:@"code"];
                
                int a = [code intValue];
                if(a==0)
                {
                    story_popularity=[responseObject objectForKey:@"petPhotoList"];
                    _po(story_popularity);
                    _pn([story_popularity count]);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

            rowHeigh=190;
            [_tableView reloadData];}

            break;
        case 102:
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:@"2" forKey:@"type"];

            _po(@"333");
            [self getDate:URL_Story_Four_To_One andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *code =[responseObject objectForKey:@"code"];
                
                int a = [code intValue];
                if(a==0)
                {
                    story_show_pet=[responseObject objectForKey:@"petPhotoList"];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            _po(story_show_pet);
            rowHeigh=90;
            [_tableView reloadData];}
            break;
        case 103:_po(@"444");
            break;
        default:
            break;
    }
}
//编辑按钮事件
-(void)EditAction{
    _po(@"1231");
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float contentoffset_y = scrollView.contentOffset.y;
    
    [self TopButtonFrameChange:contentoffset_y];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float contentoffset_y = scrollView.contentOffset.y;
    [self TopButtonFrameChange:contentoffset_y];
}
#pragma mark -
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return nil;
    }else{
        UIView *bgsectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        [bgsectionView addSubview:_topView];
        return bgsectionView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 60;
    }
    return rowHeigh;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ) {
        return 0;
    }
    return 60;
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (rowHeigh==88) {
        return [story_data count];
    }else if (rowHeigh==89) {
        return [story_star count];
        
    }else if (rowHeigh==90)
    {
        return [story_show_pet count];
    }else
    {
        if ([story_popularity count]%5==0) {
            return [story_popularity count]/5;
        }else
            return [story_popularity count]/5+1;
    
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *nullCellIdentifier = @"nullCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nullCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nullCellIdentifier];
        }
        return cell;
    }else if(indexPath.section==1&&rowHeigh==88){
        static NSString *storyCellIdentifier = @"storyCellIdentifier1";
        StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:storyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StoryCell" owner:self options:nil]lastObject];
            
        }
        if ([story_data objectAtIndex:indexPath.row]) {
            cell.TimeLabel.text=[[story_data objectAtIndex:indexPath.row] objectForKey:@"petPhotoTime"];
            cell.TitleLabel.text=[[story_data objectAtIndex:indexPath.row] objectForKey:@"petPhotoTitle"];
            cell.UserNameLabel.text=[[story_data objectAtIndex:indexPath.row] objectForKey:@"userName"];
            NSURL *url = [NSURL URLWithString:[[story_data objectAtIndex:indexPath.row] objectForKey:@"userHead"]];
            [cell.ImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1&&rowHeigh==89){
        static NSString *storyCellIdentifier = @"storyCellIdentifier";
        LikePetCell *cell = [tableView dequeueReusableCellWithIdentifier:storyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LikePetCell" owner:self options:nil]lastObject];
        }
        if ([story_star objectAtIndex:indexPath.row]) {
            cell.titleLable.text=[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoTitle"];
            cell.contentLabel.text=[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoDes"];
            NSString *stringInt = [NSString stringWithFormat:@"%@",[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoGood"]];
            NSString *stringInt1 = [NSString stringWithFormat:@"%@",[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoView"]];
            
            
            cell.lookLabel.text=stringInt;
            cell.likeLabel.text=stringInt1;
            
            NSURL *url = [NSURL URLWithString:[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoImg"]];
            [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==1&&rowHeigh==90){
        static NSString *likePetCellIdentifier = @"LikePetCellIdentifier";
        LikePetCell *cell = [tableView dequeueReusableCellWithIdentifier:likePetCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LikePetCell" owner:self options:nil]lastObject];
            
        }
        if ([story_show_pet objectAtIndex:indexPath.row]) {
            cell.titleLable.text=[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoTitle"];
            cell.contentLabel.text=[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoDes"];
            NSString *stringInt = [NSString stringWithFormat:@"%@",[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoGood"]];
            NSString *stringInt1 = [NSString stringWithFormat:@"%@",[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoView"]];
            
            
            cell.lookLabel.text=stringInt;
            cell.likeLabel.text=stringInt1;
            
            NSURL *url = [NSURL URLWithString:[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoImg"]];
            [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *showPetCellIdentifier = @"ShowPetCellIdentifier";
        ShowPetCell *cell = [tableView dequeueReusableCellWithIdentifier:showPetCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShowPetCell" owner:self options:nil]lastObject];
            NSMutableArray *urlArray=[[NSMutableArray alloc]init];
           // urlArray=nil;
             NSMutableArray *imageViewArray=[[NSMutableArray alloc]init];
             NSMutableArray *goodArray=[[NSMutableArray alloc]init];
            for (int n=0; n<[story_popularity count]; n++) {
                NSURL *url = [NSURL URLWithString:[[story_popularity objectAtIndex:n] objectForKey:@"petPhotoImg"]];
                [urlArray addObject:url];
            NSString *a=  [[story_popularity objectAtIndex:n] objectForKey:@"petPhotoGood"];
                NSString *stringInt = [NSString stringWithFormat:@"%@",a];
                [goodArray addObject:stringInt];
               
            }
            _po(goodArray);

            for (int i=0; i<[story_popularity count]/5; i++) {
                if (indexPath.row==i) {
                    for (int n=0; n<5; n++) {
                        
                    
                                       [cell.imageView1 setImageWithURL:[urlArray objectAtIndex:0+i*5] placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                        [cell.imageView2 setImageWithURL:[urlArray objectAtIndex:1+i*5] placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                        [cell.imageView3 setImageWithURL:[urlArray objectAtIndex:2+i*5] placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                        [cell.imageView4 setImageWithURL:[urlArray objectAtIndex:3+i*5] placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                        [cell.imageView5 setImageWithURL:[urlArray objectAtIndex:4+i*5] placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                     
                        cell.praiseLabel1.text=[goodArray objectAtIndex:0+i*5];
                        cell.praiseLabel2.text=[goodArray objectAtIndex:1+i*5];
                        cell.praiseLabel3.text=[goodArray objectAtIndex:2+i*5];
                        cell.praiseLabel4.text=[goodArray objectAtIndex:3+i*5];
                        cell.praiseLabel5.text=[goodArray objectAtIndex:4+i*5];
                        cell.imageView1.tag=0+i*5+1000;
                        cell.imageView2.tag=1+i*5+1000;
                        cell.imageView3.tag=2+i*5+1000;
                        cell.imageView4.tag=3+i*5+1000;
                        cell.imageView5.tag=4+i*5+1000;
                        cell.imageView1.userInteractionEnabled=YES;
                        cell.imageView2.userInteractionEnabled=YES;
                        cell.imageView3.userInteractionEnabled=YES;
                        cell.imageView4.userInteractionEnabled=YES;
                        cell.imageView5.userInteractionEnabled=YES;
                        [imageViewArray addObject:cell.imageView1];
                        [imageViewArray addObject:cell.imageView2];
                        [imageViewArray addObject:cell.imageView3];
                        [imageViewArray addObject:cell.imageView4];
                        [imageViewArray addObject:cell.imageView5];
                      
                       }
                    }
                }
            
            for(UIImageView *imageView in imageViewArray)
            { UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
                [imageView addGestureRecognizer:singleTap];
                //                        [cell.imageView2 addGestureRecognizer:singleTap];
                //                        [cell.imageView3 addGestureRecognizer:singleTap];
                //                        [cell.imageView4 addGestureRecognizer:singleTap];
                //                        [cell.imageView5 addGestureRecognizer:singleTap];
            }
//            NSURL *url1 = [NSURL URLWithString:[[story_popularity objectAtIndex:indexPath.row] objectForKey:@"petPhotoImg"]];
//            [cell.imageView1 setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
//            NSURL *url2 = [NSURL URLWithString:[[story_popularity objectAtIndex:indexPath.row] objectForKey:@"petPhotoImg"]];
//            [cell.imageView2 setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
        
        
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
                return cell;
  
    }

}
-(void)imageViewClick:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTouchesRequired==1) {
        _pn(sender.view.tag);
        for (int i=0; i<[story_popularity count]; i++) {
            if (sender.view.tag==1000+i) {
                [self.navigationController pushViewController:[[StoryContentViewController alloc] init] animated:YES];
            }
        }
    

    }
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (rowHeigh==88&&indexPath.section==1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[[story_data objectAtIndex:indexPath.row] objectForKey:@"petPhotoId"]  forKey:@"petPhotoId"];
        [dic setValue:UD_userID_Str forKey:@"userId"];
        
        
        [self getDate:URL_Pet_Photo andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code =[responseObject objectForKey:@"code"];
            NSLog(@"%@",code);
            
            int a = [code intValue];
            if(a==0)
            {
                NSDictionary *dic=[responseObject objectForKey:@"petPhoto"];
                StoryContentViewController *scvc =[[StoryContentViewController alloc] init];
                
                scvc.petImageViewURL=[dic objectForKey:@"petPhotoImg"];
                scvc.petPresentation=[dic objectForKey:@"petPhotoText"];
                [self.navigationController pushViewController:scvc animated:YES];
                
                NSLog(@"登录成功");
            }else if(a==1001)
            {
                // 去登陆  缺少userID
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    
    }else if (rowHeigh==89&&indexPath.section==1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[[story_star objectAtIndex:indexPath.row] objectForKey:@"petPhotoId"]  forKey:@"petPhotoId"];
        [dic setValue:UD_userID_Str forKey:@"userId"];
        
        
        [self getDate:URL_Pet_Photo andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code =[responseObject objectForKey:@"code"];
            NSLog(@"%@",code);
            
            int a = [code intValue];
            if(a==0)
            {
                NSDictionary *dic=[responseObject objectForKey:@"petPhoto"];
                StoryContentViewController *scvc =[[StoryContentViewController alloc] init];
                
                scvc.petImageViewURL=[dic objectForKey:@"petPhotoImg"];
                scvc.petPresentation=[dic objectForKey:@"petPhotoText"];
                [self.navigationController pushViewController:scvc animated:YES];
                
                NSLog(@"登录成功");
            }else if(a==1001)
            {
                // 去登陆  缺少userID
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else if (rowHeigh==90&&indexPath.section==1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[[story_show_pet objectAtIndex:indexPath.row] objectForKey:@"petPhotoId"]  forKey:@"petPhotoId"];
        [dic setValue:UD_userID_Str forKey:@"userId"];
        
        
        [self getDate:URL_Pet_Photo andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code =[responseObject objectForKey:@"code"];
            NSLog(@"%@",code);
            
            int a = [code intValue];
            if(a==0)
            {
                NSDictionary *dic=[responseObject objectForKey:@"petPhoto"];
                StoryContentViewController *scvc =[[StoryContentViewController alloc] init];
                
                scvc.petImageViewURL=[dic objectForKey:@"petPhotoImg"];
                scvc.petPresentation=[dic objectForKey:@"petPhotoText"];
                [self.navigationController pushViewController:scvc animated:YES];
                
                NSLog(@"登录成功");
            }else if(a==1001)
            {
                // 去登陆  缺少userID
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self loadData];
//}
-(void)loadData
{
    [self getDate:URL_Story andParams:nil andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        
        int a = [code intValue];
        if(a==0)
        {
           story_data=[responseObject objectForKey:@"petPhotoList"];
            rowHeigh=88;
            [_tableView reloadData];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


}
@end
