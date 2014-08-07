//
//  MyViewController.m
//  宠信
//
//  Created by tenyea on 14-7-8.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyViewController.h"
#import "TenyeaBaseNavigationViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PetModel.h"
#import "UIImageView+WebCache.h"
#import "AddPetViewController.h"
#import "AboutViewController.h"
#import "MyAskViewController.h"
#import "MyPostViewController.h"
#import "UIButton+WebCache.h"
#import "MyInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"

#define bgTabelViewTag 100
@interface MyViewController ()
{
    NSString *_userName;
    UITableView *_tableView;
    //    顶部背景图
    UIView *_topView;
    
    NSArray *_noLoginNameArr;
    NSArray *_noLoginImageArr;
    
    NSArray *_petArr;
    
    //    登陆后和未登录的背景view
    UIView *_bgView;
    
    //    头像
    UIButton *_headButton;
    //    用户名
    UILabel *_usernameLabel;
    //    地址
    UILabel *_addressLabel;
    //    性别
    UIImageView *_sexImageView;
}
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  初始化数据
    [self _initData];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    [self.view addSubview:_tableView];
    //    headview
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    _tableView.tableHeaderView = headerView;
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 70)];
    _topView.backgroundColor = [UIColor redColor];
    [headerView addSubview:_topView];
    
    //    top的背景图
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -180, ScreenWidth, 250)];
    topImageView.backgroundColor = [UIColor greenColor];
    topImageView.image = [UIImage imageNamed:@"load_headimg_bg.png"];
    [_topView addSubview:topImageView];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _topView.height)];
    [_topView addSubview: _bgView];
    
}
-(void)_initData{
    _noLoginNameArr = @[@[@"我的问诊",@"我的帖子",@"个人资料"],@[@"打个分,鼓励一下"],@[@"用户协议",@"关于我们"]];
    _noLoginImageArr = @[@[@"my_ask.png",@"my_dynamic.png",@"my_myInfo.png"],@[@"my_score@.png"],@[@"my_agreement.png",@"my_about.png"]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _userName = [[NSUserDefaults standardUserDefaults] stringForKey:UD_userName_Str];
    //    移除所有视图
    NSArray *arr = [_bgView subviews];
    for (UIView *view in arr) {
        [view removeFromSuperview];
        //        view  = ;
    }
    //    判断是否登陆
    if (_userName)
    {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults ]dictionaryForKey:UD_userInfo_DIC];
        if (_headButton) {
            _headButton = nil;
        }
        _headButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 60, 60)];
        _headButton.backgroundColor = [UIColor redColor];
        NSString *url = [dic objectForKey:@"userHeadMin"];
        [_headButton setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        _headButton.layer.masksToBounds = YES;
        _headButton.layer.cornerRadius = 30;
        [_headButton addTarget:self action:@selector(uploadHeadAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_headButton];
        
        //        白色背景图
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 25, 160, 35)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = .7;
        [_bgView addSubview:view];
        
        if (_usernameLabel ) {
            _usernameLabel = nil;
        }
        _usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 25, 80, 20)];
        _usernameLabel.textColor = [UIColor colorWithRed:0.9 green:0.52 blue:0.13 alpha:1];
        _usernameLabel.font = [UIFont boldSystemFontOfSize:14];
        [_bgView addSubview:_usernameLabel];
        _usernameLabel.text = [dic objectForKey:@"userNickname"];
        [_usernameLabel sizeToFit];
        
        if (_sexImageView) {
            _sexImageView = nil;
        }
        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 25, 20, 17)];
        if ([[dic objectForKey:@"userSex"] intValue] == 0) {
            [_sexImageView setImage: [UIImage imageNamed:@"my_sex_man.png"]];
        }else{
            [_sexImageView setImage: [UIImage imageNamed:@"my_sex_woman.png"]];
        }
        [_bgView addSubview:_sexImageView];
        _sexImageView.left = _usernameLabel.right + 5;
        
        //        普通图标
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20,15)];
        imageView.image = [UIImage imageNamed:@"my_address.png"];
        [view addSubview:imageView];
        
        if (_addressLabel) {
            _addressLabel = nil;
        }
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 45, 120, 15)];
        _addressLabel.textColor = [UIColor colorWithRed:0.48 green:0.4 blue:0.09 alpha:1];
        _addressLabel.font = [UIFont boldSystemFontOfSize:13];
        [_bgView addSubview:_addressLabel];
        _addressLabel.text = [[NSUserDefaults standardUserDefaults ]objectForKey:UD_nowPosition_Str];
        _po( [[NSUserDefaults standardUserDefaults ]objectForKey:UD_nowPosition_Str]);
        //        读取宠物信息
        _petArr = [[NSUserDefaults standardUserDefaults]arrayForKey:UD_pet_Array];
        
    }
    else
    {//未登录
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (ScreenWidth - 100)/2  , 0, 120, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = .7;
        [_bgView addSubview:view];
        
        
        //        登录和注册按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 59, 50)];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100;
        [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(1 + 60, 0, 59, 50)];
        [button1 setTitle:@"注册" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button1.tag = 101;
        [button1 addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button1];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(59, 10, 2, 30)];
        line.backgroundColor = [UIColor grayColor];
        [view addSubview:line];
    }
    [_tableView reloadData];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_removeButton object:nil userInfo:nil];
    [super viewWillDisappear:animated];
}
#pragma mark =
#pragma mark Action
//上传用户头像
-(void)uploadHeadAction{
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"马上照一张" otherButtonTitles:@"从手机相册选择", nil ];
    [as showInView:self.view];
}
-(void)loginAction:(UIButton *)button{
    switch (button.tag) {
        case 100:
            [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
            break;
        case 101:
            [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}
-(void)deleteCell:(UISwipeGestureRecognizer *)gestureRecognizer{
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft://往左
            _po(@"往左滑动，显示删除菜单");
            [_tableView setEditing:YES animated:YES];
            break;
        case UISwipeGestureRecognizerDirectionRight://往右
            break;
        default:
            break;
    }
}
-(void)addPetAction:(UIButton *)button{
    [self.navigationController pushViewController:[[AddPetViewController alloc]initWithPetDic:nil] animated:YES];
    //    [self presentViewController:[[AddPetViewController alloc]init]  animated:YES completion:NULL];
}
#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float contentoffset_y = scrollView.contentOffset.y;
    if (contentoffset_y> 3.5 ) {
        CGPoint point = _topView.center;
        point.y =  contentoffset_y -  3.5 +120 ;
        _topView.center = point;
    }else{
        _topView.center = CGPointMake(160, 120);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float contentoffset_y = scrollView.contentOffset.y;
    if (contentoffset_y> 3.5 ) {
        CGPoint point = _topView.center;
        point.y =  contentoffset_y -  3.5 +120 ;
        _topView.center = point;
    }else{
        _topView.center = CGPointMake(160, 120);
    }
}


#pragma mark -
#pragma mark UITableViewDataSource
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_userName) {
        if ( _petArr.count > 0 ) {
            if (indexPath.section == 0 ) {
                return YES;
            }
        }
    }
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_userName) {
        if (section == 0 ) {
            return _petArr.count == 0 ? 1:_petArr.count;
        }else{
            NSArray *arr = _noLoginNameArr[section - 1];
            return [arr count];
        }
    }
    
    NSArray *arr = _noLoginNameArr[section];
    return [arr count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    登陆了
    if (_userName) {
        if (indexPath.section == 0 ) {//宠物
//            有加号
            if (indexPath.row == 0 ) {
                static NSString *myFirstCellIdentifier = @"myFirstCellIdentifier";
                MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:myFirstCellIdentifier];
                if (cell == nil) {
                    cell = [[MyViewCell alloc]initWithEditStyle:UITableViewCellStyleDefault reuseIdentifier:myFirstCellIdentifier IndexPath:indexPath];
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250-14, 0, 44, 44)];
                    [button setImage:[UIImage imageNamed:@"my_addpet@2x.png"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(addPetAction:) forControlEvents:UIControlEventTouchUpInside];
//                    cell.accessoryView =button;
                    [cell.contentView addSubview:button];
                }
                cell.eventDelegate = self;

                UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
                UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
                //            尚未有宠物
                if (_petArr.count == 0 ) {
                    label.text = @"添加宠物";
                    imageView.image = [UIImage imageNamed:@"my_petlogo.png"];
                    cell.isEdited = NO;
                }//已经有宠物
                else{
                    NSDictionary *dic = _petArr[indexPath.row];
                    PetModel *model = [[PetModel alloc]initWithDataDic:dic];
                    label.text = model.petName;
                    [imageView setImageWithURL:[NSURL URLWithString:model.petHeadImage] placeholderImage:[UIImage imageNamed:@"my_petlogo.png"]];
                }
                return cell;
            }
//            无加号
            else{
                static NSString *myCellIdentifier = @"myCellIdentifier";
                MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
                if (cell == nil) {
                    cell = [[MyViewCell alloc]initWithEditStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier IndexPath:indexPath];
                }
                
                cell.eventDelegate = self;
                UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
                UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
                cell.accessoryType = UITableViewCellAccessoryNone;
                NSDictionary *dic = _petArr[indexPath.row];
                PetModel *model = [[PetModel alloc]initWithDataDic:dic];
                label.text = model.petName;
                [imageView setImageWithURL:[NSURL URLWithString:model.petHeadImage] placeholderImage:[UIImage imageNamed:@"my_petlogo@2x.png"]];
                return cell;
            }
        }
        //非宠物
        else{
            static NSString *loginIdentifier = @"loginIdentifier";
            MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:loginIdentifier];
            if (cell == nil) {
                cell = [[MyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loginIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
//            label.text = _noLoginNameArr[indexPath.section][indexPath.row];
            UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
//            imageView.image = [UIImage imageNamed:_noLoginImageArr[indexPath.section][indexPath.row]];
            label.text = _noLoginNameArr[indexPath.section-1][indexPath.row];
            imageView.image = [UIImage imageNamed:_noLoginImageArr[indexPath.section - 1][indexPath.row]];
            return cell;

        }
    }//未登陆
    else{
        static NSString *noLoginIdentifier = @"noLoginIdentifier";
        MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:noLoginIdentifier];
        if (cell == nil) {
            cell = [[MyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noLoginIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
        label.text = _noLoginNameArr[indexPath.section][indexPath.row];
        UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
        imageView.image = [UIImage imageNamed:_noLoginImageArr[indexPath.section][indexPath.row]];
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_userName) {
        return ([_noLoginNameArr count] + 1 );
    }
    return [_noLoginNameArr count];
    
}
#pragma mark -
#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_userName) {
        if ( _petArr.count > 0 ) {
            if (indexPath.section == 0 ) {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (_userName) {
            if (indexPath.section == 0) {
                [self.navigationController pushViewController:[[AddPetViewController alloc] initWithPetDic:(_petArr.count == 0 ? nil : _petArr[indexPath.row]) ] animated:YES];
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {//我的问诊
                    [self.navigationController pushViewController:[[MyAskViewController alloc]init] animated:YES];
                }else if(indexPath.row == 1){//我的帖子
                    [self.navigationController pushViewController:[[MyPostViewController alloc]init] animated:YES];
                }else{//个人资料
                    
                    [self.navigationController pushViewController:[[MyInfoViewController alloc]init] animated:YES];
                    
                }
            }
        }else{
            [self.navigationController pushViewController:[[LoginViewController alloc] init]  animated:YES];
        }
    }else if(indexPath.section == 1 ){
        if (_userName) {
            if (indexPath.section == 0) {
                [self.navigationController pushViewController:[[AddPetViewController alloc] initWithPetDic:(_petArr.count == 0 ? nil : _petArr[indexPath.row]) ] animated:YES];
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {//我的问诊
                    [self.navigationController pushViewController:[[MyAskViewController alloc]init] animated:YES];
                }else if(indexPath.row == 1){//我的帖子
                    [self.navigationController pushViewController:[[MyPostViewController alloc]init] animated:YES];
                }else{//个人资料
                    
                    [self.navigationController pushViewController:[[MyInfoViewController alloc]init] animated:YES];
                    
                }
            }
        }
    }
    else{
        if(_userName? indexPath.section == 2 :indexPath.section == 1){//打分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app/id%d",itunesappid];
            //                @"http://itunes.apple.com/us/app/%E4%B8%9C%E5%8C%97%E6%96%B0%E9%97%BB%E7%BD%91/id802739994?ls=1&mt=8"
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else if (_userName? indexPath.section == 3 :indexPath.section == 2){
            [self.navigationController pushViewController:[[AboutViewController alloc] initWithTitle:(indexPath.row == 0? @"用户协议":@"关于我们") andFileName:(indexPath.row == 0? @"agreement":@"about")] animated:YES];
        }

    }
}
#pragma mark ----------ActionSheet 按钮点击-------------
#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"用户点击的是第%d个按钮",buttonIndex);
    switch (buttonIndex) {
        case 0:
            //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }
            break;
        case 1:
            //搞一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    关闭navigation
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    获取图片
    UIImage  * image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    image = [self scaleToSize:image size:CGSizeMake(200, 200)];
    //    如果是照相的图片。保存到本地
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//保存到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }else{
        [_headButton setImage:image forState:UIControlStateNormal];
    }
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //    提示图片上传中
    [self showHudInBottom:@"上传中。。"];
    //    发送请求
    NSString *userMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str];
    [manager POST:[BASE_URL stringByAppendingPathComponent:URL_uploadUserImage_Post] parameters:@{@"userId":userMemberId} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        需要上传的图片
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"userHeadImage" fileName:@"userHead.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            NSString *newHeadImage = [[responseObject objectForKey:@"user"] objectForKey:@"userHeadMin"];
            [_headButton setImageWithURL:[NSURL URLWithString:newHeadImage] forState:UIControlStateNormal placeholderImage:image];
            [self removeHUD];
            [self showHudInBottom:@"上传成功"];
            //            更新本地userdefaults
            NSDictionary *userDic = [responseObject objectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:UD_userInfo_DIC];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"上传失败"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    }];

}
#pragma mark -
#pragma mark Method
//保存成功或失败
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        _po(@"保存失败");
    }else {
        image = [self scaleToSize:image size:CGSizeMake(200, 200)];
        [_headButton setImage:image forState:UIControlStateNormal];
    }
}

//图片缩放到指定大小尺寸
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
#pragma mark EditDelegate
-(void)deleteAction :(NSIndexPath *)indexPath{
    NSDictionary *petDic = _petArr[indexPath.row];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
    [params setObject:[petDic objectForKey:@"petId"] forKey:@"petId"];
    
    [self showHudInBottom:@"删除中"];
    [self getDate:URL_deletePet andParams:params andcachePolicy:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            [self removeHUD];
            NSArray *petArr = [responseObject objectForKey:@"pet"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:UD_pet_Array];
            [user setObject:petArr forKey:UD_pet_Array];
            [user synchronize];
            _petArr = petArr;
            [_tableView reloadData];
        }else if([[responseObject objectForKey:@"code"] intValue]==1001){//失败
            [self removeHUD];
            [self showHudInBottom:@"删除失败"];
            [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
            return ;
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"删除失败"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    }];
}
@end
