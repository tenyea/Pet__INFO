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
#import "LikePetCell.h"
#import "StoryContentViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "NearPetViewController.h"
#import "ShowShowViewController.h"
#define offsetY 64
/*
 rowHeigh 
 88 故事
 89 明星
 90 人气
 190 嗮萌宠
 */
@interface StoryViewController ()
{
    UIView *_topView;
    int rowHeigh;
    NSArray *_dataArr;
    NSMutableDictionary *params ;
    
    
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
/**
 *  初始化视图
 */
-(void)_initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.99 blue:1 alpha:1];
    _tableView.showsVerticalScrollIndicator = NO;
    /**
     头部视图
     */
    [self _initTOPView];

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    _tableView.tableHeaderView = headerView;
    _tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:0.95 green:0.99 blue:1 alpha:1];
    
//  编辑按钮
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(EditAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"story_edit.png"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    //    上拉
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    下拉
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
/**
 *  监听tableview的高度，来调整按钮的位置
 *
 *  @param keyPath <#keyPath description#>
 *  @param object  <#object description#>
 *  @param change  <#change description#>
 *  @param context <#context description#>
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = [change objectForKey:@"new"];
        
        CGPoint point = [value CGPointValue];
        float contentoffset_y = point.y;
        if (contentoffset_y>= -64+60) {
            _topView.top = 4;
            //        结束
            for (int i = 0  ; i < 4 ; i ++ ) {
                int tag = 100 + i ;
                MoveButton *button = (MoveButton *)VIEWWITHTAG(_topView, tag);
                button.center = CGPointMake(40 + (i/2) * 80 + (i%2) * 160 , 90);
                [button buttonRun:1];
            }
        }else{
            _topView.top =  -contentoffset_y;
//            开始状态
            if ( (-contentoffset_y) > 63) {
                //        开始
                for (int i = 0  ; i < 4 ; i ++ ) {
                    int tag = 100 + i ;
                    MoveButton *button = (MoveButton *)VIEWWITHTAG(_topView, tag);
                    button.center = CGPointMake( (i%2) * 160 +80 , (i/2) *60 +30);
                    [button buttonRun:0];
                }
            }
//            移动状态
            else {
                float now_offset = (64 + contentoffset_y) /60;
                for (int i = 0  ; i < 4 ; i ++ ) {
                    int tag = 100 + i ;
                    MoveButton *button = (MoveButton *)VIEWWITHTAG(_topView, tag);
                    CGPoint point = button.center ;
                    if(i/2 == 0){//上面两个
                        point.x = (80 + 160 * (i%2) - now_offset*40 * [self highMovepath:now_offset] )  ;
                        point.y = 30 + now_offset * 60;
                    }else {//下面俩
                        point.x = 80 + 160 * (i%2) +now_offset*40 *  [self lowMovepath:now_offset];
//                        point.y = 90 - now_offset *  - 64;
                    }
                    button.center = point;
                    [button buttonRun:now_offset];
                }
 
            }
        }
    }
}
/**
 *   初始化顶部4个按钮
 */
-(void)_initTOPView{
    
    NSArray *nameArr = @[@"宠物明星",@"晒萌宠",@"人气萌宠",@"附近宠物"];
    NSArray *imageArr = @[@"story_star.png",@"story_image.png",@"story_sentiment.png",@"story_near.png"];
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, (nameArr.count/2)*60 )];
    _topView.backgroundColor = [UIColor colorWithRed:0.95 green:0.99 blue:1 alpha:1];
    for (int i = nameArr.count-1; i >= 0; i --) {
        MoveButton *button = [[MoveButton alloc]initWithFrame:CGRectMake(45 + i%2 *160, (i/2 )*60 +10 , 70, 40) LabelText:nameArr[i] ImageView:imageArr[i]];
        button.backgroundColor = [UIColor colorWithRed:0.36 green:0.68 blue:0.89 alpha:1];
        button.tag = i +100;
        [button addTarget:self action:@selector(TouchAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [_topView addSubview:button];
    }
    [self.view addSubview:_topView];
}

#pragma mark -
#pragma mark method

/**
 *  下排按钮移动公式
 *
 *  @param x x坐标位置
 *
 *  @return y的位置
 */
-(float)lowMovepath:(float)x{
    float result = 0.0;
    result = -2*x + 3;
    return result;
}
/**
 *  上排按钮移动公式
 *
 *  @param x x坐标位置
 *
 *  @return y的位置
 */
-(float)highMovepath:(float)x{
    float result = 0.0;
    result = -1.7*x + 2.7;
    return result;
}
/**
 *  将数组转化成 5个位一个单位的新数组
 *  生成新的date数组  ===》rowHeigh == 190
 *
 *  @param  旧数组
 *
 *  @return 新数组
 */
-(NSMutableArray *)buildArray :(NSArray *)dataArr{
    NSMutableArray *arr  = [[NSMutableArray alloc]init];
    int count = 0 ;
    if (dataArr.count%5 == 0 ) {
        count = dataArr.count/5;
    }else{
        count = dataArr.count/5 + 1;
    }
    for (int i = 0 ; i < count; i ++ ) {
        //不足5个
        if ( i == (count- 1)) {
            
            NSMutableArray *array = [[NSMutableArray alloc]init];
            int sub = dataArr.count - 5* i;
            for (int j = 0 ; j < sub; j ++) {
                [array addObject:dataArr[5*i + j]];
            }
            [arr addObject:array];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int j = 0 ; j <5; j ++ ) {
                [array addObject:dataArr[5*i + j]];
            }
            [arr addObject:array];
        }
        
    }
    return arr;
}


#pragma mark -
#pragma mark Action
//topview下4个按钮事件
-(void)TouchAction:(UIButton *)button {
    switch (button.tag) {
        params = [[NSMutableDictionary alloc]init];
            
        case 100: //宠物明星
        {
            [params setValue:@"1" forKey:@"type"];
            rowHeigh = 89;
            [self loadData:NO];
        }
            break;
        case 101: //嗮萌宠
        {
            [params setValue:@"0" forKey:@"type"];
            rowHeigh = 190;
            [self loadData :NO];
            
        }
            break;
        case 102://人气萌宠
        {
            [params setValue:@"2" forKey:@"type"];
            rowHeigh = 90;
            [self loadData:NO];
            
        }
            break;
        case 103:_po(@"444");
            [self.navigationController pushViewController:[[NearPetViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}
//编辑按钮事件
-(void)EditAction{
    [self.navigationController pushViewController:[[ShowShowViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeigh;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArr count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(rowHeigh==88)//故事
    {
        static NSString *storyCellIdentifier = @"storyCellIdentifier1";
        StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:storyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StoryCell" owner:self options:nil]lastObject];
            
        }
        if ([_dataArr objectAtIndex:indexPath.row]) {
            cell.dic = [_dataArr objectAtIndex:indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(rowHeigh==89)//明星
    {
        static NSString *likePetCellIdentifier = @"LikePetCellIdentifier";
        LikePetCell *cell = [tableView dequeueReusableCellWithIdentifier:likePetCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LikePetCell" owner:self options:nil]lastObject];
        }
        if ([_dataArr objectAtIndex:indexPath.row]) {
            cell.dic = [_dataArr objectAtIndex:indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(rowHeigh==90)//人气
    {
        static NSString *likePetCellIdentifier = @"LikePetCellIdentifier";
        LikePetCell *cell = [tableView dequeueReusableCellWithIdentifier:likePetCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LikePetCell" owner:self options:nil]lastObject];
            
        }
        if ([_dataArr objectAtIndex:indexPath.row]) {
            cell.dic = [_dataArr objectAtIndex:indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        static NSString *showPetCellIdentifier = @"ShowPetCellIdentifier";
        ShowPetCell *cell = [tableView dequeueReusableCellWithIdentifier:showPetCellIdentifier];
        if (cell == nil) {
            cell = [[ShowPetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showPetCellIdentifier];
        }
        cell.eventDelegate = self;
        if ([_dataArr objectAtIndex:indexPath.row]) {
            cell.dataArr = _dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (rowHeigh == 190) {
        
    }else{
        NSUserDefaults *myUserDefaults = [NSUserDefaults standardUserDefaults];
        
        
        // 读取
        NSNumber *readCount = [myUserDefaults objectForKey:UD_userID_Str];
        if (readCount) {
            NSString *petPhotoId = [_dataArr[indexPath.row]  objectForKey:@"petPhotoId"];
            StoryContentViewController *scvc =[[StoryContentViewController alloc] initWithID:petPhotoId hasComments:YES];
            [self.navigationController pushViewController:scvc animated:YES];
        }else{
            // 去登陆  缺少userID
            [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
            
        }
        
    }
    
    
}
#pragma mark -
#pragma mark LoadData
/**
 *  获取数据
 *
 *  @param isEndRefreshing 是否有结束回滚的动画
 */
-(void)loadData:(BOOL)isEndRefreshing
{

    [self showHUDwithLabel:@"加载中" inView: self.view];

    [self getDate:URL_Story_Four_To_One andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeHUD];

        NSString *code =[responseObject objectForKey:@"code"];
        int a = [code intValue];
        if(a==0)
        {
            _dataArr=[responseObject objectForKey:@"petPhotoList"];
            if (rowHeigh == 190) {
                NSMutableArray *arr = [self buildArray:_dataArr];
                _dataArr = [[NSArray alloc]initWithArray:arr];
            }
            if (_dataArr > 0 ) {
                [_tableView reloadData];
            }
        }else{
            [self showHudInBottom:@"出错了." autoHidden:YES];
        }
        if (isEndRefreshing) {
            [_tableView headerEndRefreshing];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self removeHUD];
        if (isEndRefreshing) {
            [_tableView headerEndRefreshing];
            
        }
        [self showHudInBottom:@"出错了." autoHidden:YES];
    }];
}
/**
 *  刷新故事页内容
 */
-(void)refreshData{
    [self refreshData:NO];
}
/**
 *  用于外部刷新数据
 *  外部刷新数据
 *
 *  @param isEndRefreshing 是否有结束回滚的动画
 */
-(void)refreshData : (BOOL)isEndRefreshing{
    params = [[NSMutableDictionary alloc]init];
    rowHeigh=88;
    [self showHUDwithLabel:@"加载中" inView: self.view];
    [self getDate:URL_Story andParams:nil andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code =[responseObject objectForKey:@"code"];
        [self removeHUD];

        int a = [code intValue];
        if(a==0)
        {
            _dataArr=[responseObject objectForKey:@"petPhotoList"];
            [_tableView reloadData];
        }else{
            [self showHudInBottom:@"出错了." autoHidden:YES];

        }
        if (isEndRefreshing) {
            [_tableView headerEndRefreshing];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self removeHUD];
        if (isEndRefreshing) {
            [_tableView headerEndRefreshing];
            
        }
        [self showHudInBottom:@"出错了." autoHidden:YES];
    }];

}

#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    if (rowHeigh == 88) {
        [self refreshData:YES];
    }else{
        [self loadData:YES];
    }
}
//下拉 加载
-(void)footerRereshing{
//  故事
    if (rowHeigh == 88) {
        NSMutableDictionary *rereshingParams = [[NSMutableDictionary alloc]init];
        if (_dataArr.count > 0) {
            NSDictionary *dic = [_dataArr lastObject];
            [rereshingParams setObject:[dic objectForKey:@"petPhotoId"] forKey:@"lastId"];
        }
        [self showHUDwithLabel:@"加载中" inView: self.view];
        [self getDate:URL_Story andParams:rereshingParams andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *code =[responseObject objectForKey:@"code"];
            [self removeHUD];
            
            int a = [code intValue];
            if(a==0)
            {
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
                NSArray *arr = [responseObject objectForKey:@"petPhotoList"];
                if (arr.count > 0) {
                    NSMutableArray *mArr = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i < arr.count ; i ++ ) {
                        NSDictionary *dic = arr[i];
                        [mArr addObject: dic];
                    }
                    [array  addObjectsFromArray:mArr];
                    _dataArr = [[NSArray alloc]initWithArray:array];
                }
                if (_dataArr.count > 0 ) {
                    [_tableView reloadData];
                }
            }else{
                [self showHudInBottom:@"出错了." autoHidden:YES];
            }
                [_tableView footerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            [self removeHUD];
            [_tableView footerEndRefreshing];
            [self showHudInBottom:@"出错了." autoHidden:YES];
        }];
        return;
    }
    
//    设置参数
    NSMutableDictionary *rereshingParams = [[NSMutableDictionary alloc]initWithDictionary:params];
    if (rowHeigh == 190) {
        if (_dataArr.count > 0) {
            NSDictionary *dic = [[_dataArr lastObject] lastObject];
            [rereshingParams setObject:[dic objectForKey:@"petPhotoId"] forKey:@"lastId"];
        }
    }
    else{
        if (_dataArr.count > 0) {
            NSDictionary *dic = [_dataArr lastObject];
            [rereshingParams setObject:[dic objectForKey:@"petPhotoId"] forKey:@"lastId"];
        }

    }
    [self showHUDwithLabel:@"加载中" inView: self.view];
    [self getDate:URL_Story_Four_To_One andParams:rereshingParams andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeHUD];

        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            if (rowHeigh == 190) {
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
                NSArray *arr = [responseObject objectForKey:@"petPhotoList"];
//                补从数据
                if (arr.count > 0) {
                    
//                    上一个是否已经够数
                    if ([[_dataArr lastObject] count] == 5) {
                        
                    }else{
                        int lastcount = [[_dataArr lastObject] count];
//                        最后一个数组
                        NSMutableArray *lastArr = [[NSMutableArray alloc] initWithArray:[_dataArr lastObject]];
//                        取出数据后的新数组
                        NSMutableArray *newArr = [[NSMutableArray alloc]initWithArray:arr];

//                        从arr数据中  取出需要填充的数据 并填充
                        for (int i = 0 ; i < (5 - lastcount); i ++ ) {
                            [lastArr addObject:arr[i]];
                            [newArr removeObjectAtIndex:i];
                            
                        }
//                        替换最后一组数据
                        [array replaceObjectAtIndex:([_dataArr count] -1) withObject:lastArr];
                        
//                        剩下的数组
                        arr = [NSArray arrayWithArray:newArr];
                    }
                    
//                        计算剩下的数据，并填充
                    
//                    剩下的数据分组
                    NSMutableArray *remainArr = [self buildArray:arr];
                    [array addObjectsFromArray:remainArr];
                    _dataArr = [[NSArray alloc]initWithArray:array];
                }
                if (_dataArr.count > 0 ) {
                    [_tableView reloadData];
                }
                
            }else{
                NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
                NSArray *arr = [responseObject objectForKey:@"petPhotoList"];
                if (arr.count > 0) {
                    NSMutableArray *mArr = [[NSMutableArray alloc]init];
                    for (int i = 0 ; i < arr.count ; i ++ ) {
                        NSDictionary *dic = arr[i];
                        [mArr addObject: dic];
                    }
                    [array  addObjectsFromArray:mArr];
                    _dataArr = [[NSArray alloc]initWithArray:array];
                }
                if (_dataArr.count > 0 ) {
                    [_tableView reloadData];
                }
            }

        }else{
            
        }
        [_tableView footerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [_tableView footerEndRefreshing];
        [self showHudInBottom:@"出错了." autoHidden:YES];    }];

}

#pragma mark -
#pragma mark pushVCDelegate
/**
 *  嗮萌宠选择图片的事件
 *
 *  @param petPhotoId 选择的图片id
 */
-(void)pushVC:(NSString *)petPhotoId{
    [self.navigationController pushViewController:[[StoryContentViewController alloc] initWithID:petPhotoId hasComments:YES] animated:YES];
}
@end
