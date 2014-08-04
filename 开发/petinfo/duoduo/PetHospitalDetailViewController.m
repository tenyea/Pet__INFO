//
//  PetHospitalDetailViewController.m
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "PetHospitalDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HospitalModel.h"
#import "UserCommentCell.h"
#import "PetHosContentViewController.h"
#import "DoctorViewController.h"
#import "HospNewsViewController.h"
#import "EnvironmentViewController.h"
#import "EquipViewController.h"
#import "MJRefresh.h"
@interface PetHospitalDetailViewController ()
{
    NSArray *_hosInfoArr;
    UITableView *_tableView;
    int _selected;//选择的栏目
    UIView *_bottomView;//tableview背景
    UITextView *_textView;
    int countStar;//星星数量
    NSArray *_dataArr;
}
@end

@implementation PetHospitalDetailViewController
@synthesize model = model;
-(id)initWithHospitail:(HospitalModel *)hmodel{
    self = [super init];
    if (self) {
        model = hmodel;
        _hosInfoArr = @[@"医院简介",@"医师风采",@"医院动态",@"医院环境",@"医疗设备"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    countStar = 0;
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [topImageView setImageWithURL:[NSURL URLWithString:model.hosImage]];
    [self.view addSubview:topImageView];
    
    PetHosDetailView *topView = [[[NSBundle mainBundle]loadNibNamed:@"PetHosDetailView" owner:self options:nil]lastObject];
    topView.eventDelegate = self;
    topView.frame = CGRectMake(0, topImageView.bottom, ScreenWidth, 120);
    [self.view addSubview:topView];
    topView.model = model;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120 + 150 , ScreenWidth, ScreenHeight - 120 - 150- 49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;

    [self.view addSubview:_tableView];
}
#pragma mark - 
#pragma mark Action 
-(void)submitAction{
    [_textView resignFirstResponder];
    if ([_textView.text isEqualToString:@"说点什么吧"]) {
        [self showHudInBottom:@"说点什么吧"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
        return;
    }
    if (countStar == 0 ) {
        [self showHudInBottom:@"帮忙评个分吧"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:model.hosId forKey:@"hosId"];
    [params setObject:[[NSUserDefaults standardUserDefaults]stringForKey:UD_userID_Str ] forKey:@"userId"];
    [params setObject:[NSNumber numberWithInt:countStar] forKey:@"score"];
    [params setObject:_textView.text forKey:@"dis"];
    
    [self getDate:URL_UserToHosDis andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            [self removeHUD];
            [self showHudInBottom:@"评论成功"];
        }else if ([[responseObject objectForKey:@"code"] intValue]==1010){
            [self removeHUD];
            [self showHudInBottom:@"您已评论过了"];
        }else{
            [self removeHUD];
            [self showHudInBottom:@"评论失败"];
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1.5];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"评论失败"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    }];
    
}
-(void)selectStarAction:(UIButton *)button {
    for ( int i = 0 ; i < 5; i ++ ) {
        UIButton *button = (UIButton *)VIEWWITHTAG(_bottomView, 500 + i );
        button.selected = NO;
    }
    
    int tag = button.tag - 500 ;
    for ( int i = 0 ; i < tag; i ++ ) {
        UIButton *button = (UIButton *)VIEWWITHTAG(_bottomView, 500 + i);
        button.selected = YES;
    }
    button.selected = YES;
    countStar = button.tag - 500 + 1;
}

#pragma mark - 
#pragma mark PetHosDetailViewDelegate
-(void)selectedAction:(int)tag{
    _selected = tag;
    if (_selected == 2) {
        _tableView.hidden = YES;
        if (!_bottomView) {
            _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 120 + 150 , ScreenWidth, ScreenHeight - 120 - 150)];
            _bottomView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_bottomView];
            
            UIView *textBgView = [[UIView alloc]initWithFrame:CGRectMake(14, 39, ScreenWidth - 14*2, 62)];
            textBgView.backgroundColor = [UIColor blackColor];
            [_bottomView addSubview:textBgView];
            
            _textView = [[UITextView alloc]initWithFrame:CGRectMake(15,40 , ScreenWidth - 15*2, 60)];
            _textView.returnKeyType = UIReturnKeyDone;
            _textView.tag = 1200;
            _textView.delegate = self;
            _textView.text = @"说点什么吧";
            [_bottomView addSubview:_textView];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(120, 110, ScreenWidth - 120 *2, 30)];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            button.backgroundColor  = [UIColor colorWithRed:0.54 green:0.99 blue:0.42 alpha:1];
            [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 9;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
            
            
//            五角星
            
            for (int i = 0 ; i < 5; i ++ ) {
                UIButton *buttonStar = [[UIButton alloc ] initWithFrame:CGRectMake(15 + 35* i , 5, 30, 30)];
                [buttonStar setImage:[UIImage imageNamed:@"灰星.png"] forState:UIControlStateNormal];
                [buttonStar setImage:[UIImage imageNamed:@"黄星.png"] forState:UIControlStateSelected];
                buttonStar.tag = 500 + i;
                [buttonStar  addTarget: self  action:@selector(selectStarAction:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:buttonStar];
                
            }
        }else{
            _bottomView.hidden = NO;
        }
    }
    else{
        if (_bottomView) {
            _bottomView.hidden = YES;
        }
        _tableView.hidden = NO;
        if (_selected == 1) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:model.hosId forKey:@"hosId"];
            [params setObject:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
            [self getDate:URL_getHosDisList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
                    _dataArr = [responseObject objectForKey:@"hosDis"];
                    [_tableView reloadData];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                _po([error localizedDescription]);
            }];
            //    上拉
            [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
            //    下拉
            [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
        }else{
            [_tableView removeHeader];
            [_tableView removeFooter];
        }
        [_tableView reloadData];
    }
}

#pragma mark -
#pragma mark MJRefresh
//上拉 刷新
-(void)headerRereshing{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:model.hosId forKey:@"hosId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
    [self getDate:URL_getHosDisList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0 ) {
            if (_dataArr.count > 0 ) {
                _dataArr = [[NSArray alloc]init];
            }
            _dataArr = [responseObject objectForKey:@"hosDis"];
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [_tableView headerEndRefreshing];
    }];
}
//下拉 加载
-(void)footerRereshing{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:model.hosId forKey:@"hosId"];
    [params setObject:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
    if (_dataArr.count > 0) {
        NSDictionary *dic = [_dataArr lastObject];
        NSString *lastId = [dic objectForKey:@"hosStarId"];
        [params setObject:lastId forKey:@"lastId"];
    }
    [self getDate:URL_getHosDisList andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0) {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:_dataArr];
            
            NSArray *arr = [responseObject objectForKey:@"hosDis"];
            if (arr.count > 0) {
                [array  addObjectsFromArray:arr];
                _dataArr = [[NSArray alloc]initWithArray:array];
            }
            if (_dataArr.count > 0 ) {
                [_tableView reloadData];
            }
        }
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [_tableView footerEndRefreshing];
        
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selected == 0) {
        return [_hosInfoArr count];
    }else if (_selected == 1){
        return [_dataArr count];
    }else{
    
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selected == 0) {
        static NSString *hosInfoIdentifier = @"hosInfoIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hosInfoIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hosInfoIdentifier];
        }
        
        cell.textLabel.text = [_hosInfoArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;

    }else if (_selected == 1){
        
        static NSString *UserCommentIdentifier = @"UserCommentIdentifier" ;
        UserCommentCell *cell = (UserCommentCell *)  [tableView dequeueReusableCellWithIdentifier:UserCommentIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCommentCell" owner:self options:nil]lastObject];
        }
        cell.dic = _dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selected == 0) {
        return 44;
    }else if (_selected == 1){
        return 60;
    }else{
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_selected == 0) {
        return 0;
    }else if (_selected == 1){
        return 40;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_selected == 0) {
        return nil;
    }else if (_selected == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
//        label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
        label.text = @"综合评价:";
        [label sizeToFit];
        [view addSubview:label];
        [view setBackgroundColor: [UIColor whiteColor]];
//        image
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_gray_start.png"]];
        imageView.frame = CGRectMake(0, 40 -12 * 2, 50, 12);
        imageView.left = label.right + 5;
        [view addSubview:imageView];
        
        NSString *score = model.hosStar;
//        score
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
        scoreLabel.text = [NSString stringWithFormat:@"%@分", score ];
        [scoreLabel sizeToFit];
        scoreLabel.left = imageView.right + 10;
        [view addSubview:scoreLabel];

        UIImageView *yellowImageView = [[UIImageView alloc]initWithFrame:imageView.frame];
        UIImage *image = [UIImage imageNamed:@"ask_yellow_start.png"];

        [view addSubview:yellowImageView];
        
        
        float score1 = [score floatValue] * 20;
        if (score1 == 0) {
            yellowImageView.width = 0;
        }else{
            UIImage *newImage = [self getImage:image rect:CGSizeMake(score1, 24)];
            yellowImageView.width = score1 /2;
            [yellowImageView setImage: newImage];
        }
        
        UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, ScreenWidth, 1)];
        botView.backgroundColor = [UIColor colorWithRed:0.95 green:0.79 blue:0.79 alpha:1];
        [view addSubview:botView];
        return view;
    }else{
        return nil;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selected == 0) {
        switch (indexPath.row) {
            case 0://简介
                [self.navigationController pushViewController:[[PetHosContentViewController alloc] initWithUrl:URL_getHosDes id:self.model.hosId andkey:@"hosId"]  animated:YES];
                break;
            case 1://风采
                [self.navigationController pushViewController:[[DoctorViewController alloc] initWithHosId:self.model.hosId] animated:YES];

                break;
            case 2://动态
                [self.navigationController pushViewController:[[HospNewsViewController alloc] initWithHosId:self.model.hosId] animated:YES];

                break;
            case 3://环境
                [self.navigationController pushViewController:[[EnvironmentViewController alloc] initWithHosId:self.model.hosId] animated:YES];
                break;
            case 4://设备
                [self.navigationController pushViewController:[[EquipViewController alloc] initWithHosId:self.model.hosId] animated:YES];
                break;
            default:
                break;
        }
    }else if (_selected == 1){
        
    }else{
        
    }
}

#pragma mark - 
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _bottomView.transform =  CGAffineTransformMakeTranslation(0, -120-150 +64);
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"说点什么吧";
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _bottomView.transform =  CGAffineTransformIdentity;
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


//截取图片大小
- (UIImage *)getImage:(UIImage *)bigImage rect:(CGSize)reSize
{
    //截取截取大小为需要显示的大小。取图片中间位置截取
    CGRect myImageRect = CGRectMake(0, 0, reSize.width, reSize.height);
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    UIGraphicsBeginImageContext(reSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end
