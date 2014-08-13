//
//  HomeViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "HomeViewController.h"
#import "StoryCell.h"
#import "StoryContentViewController.h"
#import "PetClassificationViewController.h"
#import "UIImageView+WebCache.h"
#import "ADWebViewController.h"
#define XLCycleHeight 130
@interface HomeViewController ()
{
    float _heigh;
    NSArray *array;
    
}
@end

@implementation HomeViewController
@synthesize result=result;
@synthesize result1=result1;
@synthesize petEveryday=petEveryday;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
 _po(@"222");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       _po(@"111");
    
    petPhotoId = [result objectForKey:@"petPhotoId"];
    petPhotoPathMin =[result objectForKey:@"petPhotoPathMin"];
    petPhotoTitle = [result objectForKey:@"petPhotoTitle"];
    petPhotoDes = [result objectForKey:@"petPhotoDes"];
    petPhotoGood = [result objectForKey:@"petPhotoGood"];
 
    array=[[NSArray alloc]init];
    array=@[@"新手课堂",@"专家讲堂",@"预防护理",@"日常饲养",@"就医指南",@"宠物美容"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    self.view.backgroundColor=  [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    // tableView.scrollEnabled=NO;
    // 取消tableview的row的横线
    // tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  

    [self _loadDate];
}

#pragma mark -
#pragma mark UITableViewDataSource
// 设置一个表单中有多少分组(非正式协议如果不实现该方法则默认只有一个分组)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

// 设置一个分组中有多少行(必须实现的正式协议)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return 1;
    }else if(section==2)
    {
        return 2;
    }else
    {
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        static NSString *cellName_top = @"cell_top";
        // 声明cell并去复用池中找是否有对应标签的闲置cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_top];
        // 如果没找到可复用的cell
        if(cell == nil)
        {
            // 实例化新的cell并且加上标签
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName_top] ;
            [self _initUI];
            [cell addSubview:view];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==1)
    {
        static NSString *cellName_button = @"cellName_button";
        // 声明cell并去复用池中找是否有对应标签的闲置cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName_button];
        // 如果没找到可复用的cell
        if(cell == nil)
        {
            // 实例化新的cell并且加上标签
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName_button] ;
            
            
            int m=0;
            for (int i=0; i<2; i++) {
                for (int j=0; j<3; j++) {
                    
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake(20+j*110, 15+30*i, 60, 20);
                    [btn setTitle:[array objectAtIndex:m] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
                    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                    //  btn.titleLabel.textColor=[UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
                    btn.tag=i*10+j;
                    btn.layer.cornerRadius=4;
                    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor=[UIColor colorWithRed:0.4 green:0.75 blue:0.62 alpha:1];
                    [cell addSubview:btn];
                    m++;
                }
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row == 0) {
            static NSString *cellName1_title = @"cellName1_title";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName1_title];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName1_title];
                UIImageView *igv=[[UIImageView alloc]init];
                igv.frame=CGRectMake(10, 2, 25, 25);
                igv.image=[UIImage imageNamed:@"home_horn.png"];
                [cell addSubview:igv];
                UILabel *label = [[UILabel alloc]init];
                label.frame=CGRectMake(40, 0, 300, 30);
                label.font=[UIFont boldSystemFontOfSize:13];
                label.textColor=COLOR(59, 193, 151);
                label.text=@"本周萌宠";
                [cell addSubview:label];
                
                UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(10, 29, 300, 1)];
                bview.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                [cell addSubview:bview];
            }

            cell.selectionStyle=UITableViewCellSelectionStyleNone;

            cell.accessoryType = UITableViewCellAccessoryNone;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;

            return cell;
            
        }else{
            static NSString *cellName1_content = @"cellName1_content";
            // 声明cell并去复用池中找是否有对应标签的闲置cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName1_content];
            // 如果没找到可复用的cell
            if(cell == nil)
            {
                // 实例化新的cell并且加上标签
                //            标题
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName1_content] ;
                UILabel *label = [[UILabel alloc]init];
                label.frame=CGRectMake(100, 5, 200, 30);
                label.font=[UIFont boldSystemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:0.36 green:0.62 blue:0.11 alpha:1];
                label.tag = 100;
                
                [cell addSubview:label];
                //            内容
                UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 210, 80)];
                desc.numberOfLines = 2;
                desc.tag = 101;
                desc.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
                [cell addSubview:desc];
                //            赞数
                UILabel *label1 = [[UILabel alloc]init];
                label1.tag = 104;
                label1.frame=CGRectMake(280, 70,40, 15);
                label1.font=[UIFont boldSystemFontOfSize:12];
                label1.textColor=[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
                [cell addSubview:label1];
                
                //            左侧图
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 13;
                
                imageView.tag = 103;
                NSURL *url = [NSURL URLWithString:petPhotoPathMin];
                [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
                
                [cell addSubview:imageView];
                
                //            图片
                UIImageView *igv=[[UIImageView alloc]init];
                igv.frame=CGRectMake(283, -7, 30, 30);
                igv.image=[UIImage imageNamed:@"main_top.png"];
                [cell addSubview:igv];
                UIImageView *igv1=[[UIImageView alloc]init];
                igv1.frame=CGRectMake(260, 70, 15, 15);
                igv1.image=[UIImage imageNamed:@"main_praise.png"];
                [cell addSubview:igv1];
             //   UILabel *label = (UILabel *)VIEWWITHTAG(tableView, 100);
                label.text= petPhotoTitle;
                
              //  UILabel *desc = (UILabel *)VIEWWITHTAG(tableView, 101);
                desc.text = petPhotoDes;
                
             //   UILabel *label1 = (UILabel *)VIEWWITHTAG(tableView, 104);
                NSString *stringInt = [NSString stringWithFormat:@"%@",petPhotoGood];
                label1.text=stringInt ;
               


            }
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    
        
    }
    else
    {
        if (indexPath.row == 0) {
            static NSString *cellName2_title = @"cellName2_title";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName2_title];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2_title];
                UILabel *label = [[UILabel alloc]init];
                label.frame=CGRectMake(20, 5, 300, 30);
                label.font=[UIFont boldSystemFontOfSize:13];
                [cell addSubview:label];
                label.text=@"每日一宠";
                label.textColor=COLOR(59, 193, 151);
                UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(10, 29, 300, 1)];
                bview.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                [cell addSubview:bview];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            static NSString *cellName2_content = @"cellName2_content";
            // 声明cell并去复用池中找是否有对应标签的闲置cell
            StoryCell *cell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:cellName2_content];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"StoryCell" owner:self options:nil] lastObject];
            }
            if (petEveryday.count > 0 ) {
                petDay = [petEveryday objectAtIndex: (indexPath.row - 1)];
                petPhotoId1 = [petDay objectForKey:@"petPhotoId"];
                petPhotoTime = [petDay objectForKey:@"petPhotoTime"];
                petPhotoTitle1 = [petDay objectForKey:@"petPhotoTitle"];
                userName = [petDay objectForKey:@"userName"];
                userHead = [petDay objectForKey:@"userHead"];
                cell.TitleLabel.text=petPhotoTitle1;
                cell.TimeLabel.text=petPhotoTime;
                cell.UserNameLabel.text=userName;
                NSURL *url = [NSURL URLWithString:userHead];
                [cell.ImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"my_petlogo.png"]];
            }

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
   
}


-(void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"1");
            break;
        case 1:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"2");
            break;
        case 2:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"3");
            break;
        case 10:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"4");
            break;
        case 11:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"5");
            break;
        case 12:
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] init] animated:YES];
            _po(@"6");
            break;
        default:
            break;
    }

}


#pragma mark -
#pragma mark UITableViewDelegate
// 设置行高(默认为44px)
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return XLCycleHeight;
    }else if(indexPath.section==1)
    {
        return 80;
    }else if(indexPath.section==2)
    {
        if (indexPath.row == 0 ) {
            return 30;
        }
        return 100;
    }else{
        if (indexPath.row == 0 ) {
            return 30;
        }
        return 90;
    }
    
    
}



#pragma mark XLCycleScrollViewDelegate

- (UIView *)pageAtIndex:(NSInteger)index
{
   
        NSDictionary *ad = [result1 objectAtIndex:index];
        NSString *adId = [ad objectForKey:@"adId"];
        NSString *adTitle = [ad objectForKey:@"adTitle"];
        NSString *adImage = [ad objectForKey:@"adImage"];
        NSString *adUrl = [ad objectForKey:@"adUrl"];
       
       
    
    UIImageView *imgaeView =[[UIImageView alloc]init];
    NSURL *url = [NSURL URLWithString:adImage];
    [imgaeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"register_backgroundg.png"]];
    // imgaeView.image = [UIImage imageNamed:@"1.png"];
    imgaeView.frame = CGRectMake(0,0, ScreenWidth - 16*2, XLCycleHeight - 11 * 2);
    imgaeView.backgroundColor = [UIColor yellowColor];
    return imgaeView;

}
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    NSDictionary *ad = [result1 objectAtIndex:index];
    NSString *adId = [ad objectForKey:@"adId"];
    NSString *adTitle = [ad objectForKey:@"adTitle"];
    NSString *adImage = [ad objectForKey:@"adImage"];
    NSString *adUrl = [ad objectForKey:@"adUrl"];
    ADWebViewController *advc=[[ADWebViewController alloc]init];
    advc.url=adUrl;
     [self.navigationController pushViewController:advc animated:YES];
}
#pragma mark XLCycleScrollViewDatasource
-(void)PageExchange:(NSInteger)index{
    pageControl.currentPage = index;
    
}
- (NSInteger)numberOfPages
{
    return 3;
}
#pragma mark -
#pragma mark UI



-(void)_initUI{
//    轮播图
    view = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth, XLCycleHeight)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14, 9, ScreenWidth - 14 * 2 , XLCycleHeight - 9 * 2)];
    bgView.backgroundColor = [UIColor colorWithRed:0.48 green:0.89 blue:0.87 alpha:1];
//    图片弧度
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 13;
    [view addSubview:bgView];
    
    
    XLCycleScrollView *xlCycleScrollView = [[XLCycleScrollView alloc]initWithFrame:CGRectMake(2 , 2, ScreenWidth - 16*2, XLCycleHeight - 11 * 2)];
    xlCycleScrollView.layer.masksToBounds = YES;
    xlCycleScrollView.layer.cornerRadius = 13;
    xlCycleScrollView.delegate = self;
    xlCycleScrollView.datasource = self;
    [xlCycleScrollView.pageControl setHidden:YES];
    [bgView addSubview:xlCycleScrollView];
    
    UIView *pageControlBg = [[UIView alloc]initWithFrame:CGRectMake(240 - 12 * 4 - 5, 85, 12 * 4 + 10*2, 15)];
    pageControlBg.layer.masksToBounds = YES;
    pageControlBg.layer.cornerRadius = 8;
    pageControlBg.backgroundColor = [UIColor colorWithRed:0.22 green:0.24 blue:0.23 alpha:.8];
    [xlCycleScrollView addSubview: pageControlBg];
    //pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, 0, 12*4, 15)];
    pageControl.backgroundColor = [UIColor clearColor];
    if (WXHLOSVersion()>=6.0) {
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.55 blue:0.13 alpha:1];
    }
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = 3;
    pageControl.currentPage= 0;
    [pageControlBg addSubview:pageControl];
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  
        
    if (indexPath.section==2&&indexPath.row!=0)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:petPhotoId forKey:@"petPhotoId"];
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
       
    }else if (indexPath.section==3&&indexPath.row!=0)
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[[petEveryday objectAtIndex:indexPath.row] objectForKey:@"petPhotoId"]  forKey:@"petPhotoId"];
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

// 解析数据存储在 NSUserDefaults
-(void)showResult:(NSDictionary *)resultobject
{
    //解析数据
  //  result =[resultobject objectForKey:@"weekPetPhoto"];
    petPhotoId = [result objectForKey:@"petPhotoId"];
    petPhotoPathMin =[result objectForKey:@"petPhotoPathMin"];
    petPhotoTitle = [result objectForKey:@"petPhotoTitle"];
    petPhotoDes = [result objectForKey:@"petPhotoDes"];
    petPhotoGood = [result objectForKey:@"petPhotoGood"];
   
   
 //  petEveryday = [resultobject objectForKey:@"petPhotoList"];
    NSDictionary *petDay = [petEveryday objectAtIndex:0];
    NSString *petPhotoId1 = [petDay objectForKey:@"petPhotoId"];
    NSString *petPhotoTime = [petDay objectForKey:@"petPhotoTime"];
    NSString *petPhotoTitle1 = [petDay objectForKey:@"petPhotoTitle"];
    NSString *userName = [petDay objectForKey:@"userName"];
    NSString *userHead = [petDay objectForKey:@"userHead"];
    

    
 //   result1 =[resultobject objectForKey:@"ad"];
    NSDictionary *ad = [result1 objectAtIndex:1];
    NSString *adId = [ad objectForKey:@"adId"];
    NSString *adTitle = [ad objectForKey:@"adTitle"];
    NSString *adImage = [ad objectForKey:@"adImage"];
    NSString *adUrl = [ad objectForKey:@"adUrl"];
  
    
}

#pragma mark -
#pragma mark LoadDate
-(void)_loadDate{
    
}
@end
