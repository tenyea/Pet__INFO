//
//  HomeViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "HomeViewController.h"
#import "StoryCell.h"
#import "MyPostDetailViewController.h"
#import "PetClassificationViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ADWebViewController.h"
#import "LoginViewController.h"
#import "AskViewController.h"
#import "TenyeaBaseNavigationViewController.h"
#import "MJRefresh.h"
#import "sys/utsname.h"
#import "OpenUDID.h"
#import "PetKnowledgeViewController.h"
#define XLCycleHeight 130
@interface HomeViewController ()
{
    float _heigh;
    NSArray *array;
    
    UITableView *_tableView;
    BOOL isloginType;
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
    
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    array=[[NSArray alloc]init];
    array=@[@"新手课堂",@"专家讲堂",@"预防护理",@"日常饲养",@"就医指南",@"宠物美容"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 10) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor=  [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    // tableView.scrollEnabled=NO;
    // 取消tableview的row的横线
    // tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  
    //    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [_tableView headerBeginRefreshing];
    isloginType = YES;
//    [self _loadDate];
}

#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    [self _loadDate];
}
#pragma mark -
#pragma mark UITableViewDataSource
// 设置一个表单中有多少分组(非正式协议如果不实现该方法则默认只有一个分组)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (result == nil) {
        return 3;
    }
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
        if (result == nil) {
            return [petEveryday count];
        }
        return 1;
    }else
    {
        return [petEveryday count] ;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    顶部视图
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
//    按钮
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
                    btn.frame=CGRectMake(30+j*100, 15+30*i, 60, 20);
                    [btn setTitle:[array objectAtIndex:m] forState:UIControlStateNormal];
                    btn.titleLabel.font = FONT(12);
                    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                    //  btn.titleLabel.textColor=[UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
                    btn.tag=i*10+j;
                    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor= [UIColor colorWithRed:0.42 green:0.78 blue:0.99 alpha:1];
                    [cell addSubview:btn];
                    m++;
                }
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
//    本周萌宠
    else if(indexPath.section==2)
    {
        
        if (result == nil) {
            static NSString *cellName2_content = @"cellName2_content";
            // 声明cell并去复用池中找是否有对应标签的闲置cell
            StoryCell *cell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:cellName2_content];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"StoryCell" owner:self options:nil] lastObject];
                
            }
            if (petEveryday.count > 0 ) {
                petDay = [petEveryday objectAtIndex: (indexPath.row )];
                cell.dic = petDay;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString *cellName1_content = @"cellName1_content";
        // 声明cell并去复用池中找是否有对应标签的闲置cell
        StoryCell *cell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:cellName1_content];

        // 如果没找到可复用的cell
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StoryCell" owner:self options:nil] lastObject];
            cell.isShowHot = YES;
            
            
        }
        
        if (result.count > 0 ) {
            cell.dic = result;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    
        
    }
//    每日一宠
    else
    {

        static NSString *cellName2_content = @"cellName2_content";
        // 声明cell并去复用池中找是否有对应标签的闲置cell
        StoryCell *cell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:cellName2_content];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StoryCell" owner:self options:nil] lastObject];
            
        }
        if (petEveryday.count > 0 ) {
            petDay = [petEveryday objectAtIndex: (indexPath.row )];
            cell.dic = petDay;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
   
}


-(void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 0://新手课堂
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] initWithType:@"1" ] animated:YES];
            break;
        case 1://专家讲堂
             [self.navigationController pushViewController:[[PetKnowledgeViewController alloc] initWithType:@"0" KindId:nil board:0] animated:YES];
            break;
        case 2://预防护理
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] initWithType:@"2"] animated:YES];
            break;
        case 10://日常饲养
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] initWithType:@"5" secondType:YES] animated:YES];
            break;
        case 11://就医指南
            [self.appDelegate.mainVC updateSelectedIndex:2];
            break;
        case 12://宠物美容
             [self.navigationController pushViewController:[[PetClassificationViewController alloc] initWithType:@"4"] animated:YES];
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
        return [StoryCell getCellHeigh:result];
    }else{
        return [StoryCell getCellHeigh:petEveryday[indexPath.row]];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==2)
    {
        if (result == nil) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_userID_Str]) {
                
                [self.navigationController pushViewController:[[MyPostDetailViewController alloc] initWithId:[[petEveryday objectAtIndex:indexPath.row]objectForKey:@"petPhotoId"]] animated:YES];
            }else{
                [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
            }
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_userID_Str]) {
            [self.navigationController pushViewController:[[MyPostDetailViewController alloc] initWithId:petPhotoId] animated:YES];
            
        }else{
            [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
        }
    }else if (indexPath.section==3)
    {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:UD_userID_Str]) {

            [self.navigationController pushViewController:[[MyPostDetailViewController alloc] initWithId:[[petEveryday objectAtIndex:indexPath.row]objectForKey:@"petPhotoId"]] animated:YES];
        }else{
            [self.navigationController pushViewController:[[LoginViewController alloc]init] animated:YES];
        }
    }
    
    
    
    
}


#pragma mark XLCycleScrollViewDelegate
/**
 *  轮播图显示
 *
 *  @param index 第几个
 *
 *  @return 需要显示的视图
 */
- (UIView *)pageAtIndex:(NSInteger)index
{
   
        ad = [result1 objectAtIndex:index];
        adId = [ad objectForKey:@"adId"];
        adTitle = [ad objectForKey:@"adTitle"];
        adImage = [ad objectForKey:@"adImage"];
        adUrl = [ad objectForKey:@"adUrl"];
       
       
    
    UIImageView *imgaeView =[[UIImageView alloc]init];
    NSURL *url = [NSURL URLWithString:adImage];
    [imgaeView setImageWithURL:url  ];
    imgaeView.frame = CGRectMake(0,0, ScreenWidth  , XLCycleHeight );
    return imgaeView;

}
/**
 *  轮播图点击事件代理
 *
 *  @param csView <#csView description#>
 *  @param index  <#index description#>
 */
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    ad = [result1 objectAtIndex:index];
    adId = [ad objectForKey:@"adId"];
    adTitle = [ad objectForKey:@"adTitle"];
    adImage = [ad objectForKey:@"adImage"];
    adUrl = [ad objectForKey:@"adUrl"];
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

/**
 *  初始化视图
 */
-(void)_initUI{
//    轮播图背景图
    view = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth, XLCycleHeight)];

    
    //轮播图控件
    XLCycleScrollView *xlCycleScrollView = [[XLCycleScrollView alloc]initWithFrame:CGRectMake(0 ,0, ScreenWidth , XLCycleHeight )];
    xlCycleScrollView.delegate = self;
    xlCycleScrollView.datasource = self;
    [xlCycleScrollView.pageControl setHidden:YES];
    [view addSubview:xlCycleScrollView];
    
    UIView *pageControlBg = [[UIView alloc]initWithFrame:CGRectMake(300 - 12 * 4 - 5, XLCycleHeight - 20, 12 * 4 + 10*2, 15)];
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




/**
 *  图片缩放到指定大小尺寸
 *
 *  @param img  原始图片
 *  @param size 新图片大小
 *
 *  @return 新的图片
 */
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark -
#pragma mark LoadDate
/**
 *  获取数据，填充
 */
-(void)_loadDate{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str]) {
        if (isloginType) {
            [dic setObject:@"1" forKey:@"isLogin"];
            struct utsname systemInfo;
            uname(&systemInfo);
            NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str] forKey:@"userId"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UD_userName_Str] forKey:@"username"];
            [dic setObject:[OpenUDID value] forKey:@"deviceId"];
            NSDictionary *dicLocationnow =  [[NSUserDefaults standardUserDefaults]dictionaryForKey:UD_Locationnow_DIC];
            if (dicLocationnow) {
                [dic setObject:[dicLocationnow objectForKey:@"longitude"]  forKey:@"longitude"];
                [dic setObject:[dicLocationnow objectForKey:@"latitude"] forKey:@"latitude"];
            }else{
                [dic setObject:@"0"  forKey:@"longitude"];
                [dic setObject:@"0" forKey:@"latitude"];
                
            }
            [dic setObject:deviceString forKey:@"device"];
            [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"system"];
            [dic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"version"];
            [dic setObject:[NSString stringWithFormat:@"%f*%f",ScreenWidth,ScreenHeight] forKey:@"dpi"];
            [dic setObject:[Network  getConnectionAvailable] forKey:@"gprs"];
            [dic setObject:@"0" forKey:@"type"];
        }else{
            [dic setObject:@"0" forKey:@"isLogin"];

        }
        
    }else{
        [dic setObject:@"0" forKey:@"isLogin"];
    }
    isloginType = NO;

   
    
    
    [self getDate:URL_Ao andParams:dic andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        
        int a = [code intValue];
        if(a==0)
        {
            
            //解析数据
            if ([responseObject objectForKey:@"weekPetPhoto"]  != [NSNull null]) {
                self.result =[responseObject objectForKey:@"weekPetPhoto"];

            }
            self.petEveryday = [responseObject objectForKey:@"petPhotoList"];
            self.result1 =[responseObject objectForKey:@"ad"];
            
            petPhotoId = [result objectForKey:@"petPhotoId"];
            petPhotoPathMin =[result objectForKey:@"petPhotoPathMin"];
            petPhotoTitle = [result objectForKey:@"petPhotoTitle"];
            petPhotoDes = [result objectForKey:@"petPhotoDes"];
            petPhotoGood = [result objectForKey:@"petPhotoGood"];
            if (petEveryday.count > 0) {
                [_tableView reloadData];

            }
        }
        [_tableView headerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLOG(@"Error: %@", [error localizedDescription]);
        [_tableView headerEndRefreshing];

    }];
}
@end
