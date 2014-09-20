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
#import "UIImageView+AFNetworking.h"
#import "AddPetViewController.h"
#import "AboutViewController.h"
#import "MyAskViewController.h"
#import "MyPostViewController.h"
#import "UIButton+AFNetworking.h"
#import "MyInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MyViewCell.h"
#import "MyReplyViewController.h"
#import "MYFriendViewController.h"
#import "SettingViewController.h"
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
    
    NSDictionary *_userInfoDic;
    
    UIButton *_headButton;

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

}
-(void)_initData{
    _noLoginNameArr = @[@"我的宠友",@"我的问诊",@"我的帖子",@"我的回复",@"用户协议",@"关于我们",@"通用设置"];
    _noLoginImageArr = @[@"my_friend.png",@"my_ask.png",@"my_dynamic.png",@"my_reply.png",@"my_agreement.png",@"my_about.png",@"my_setting.png"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _userName = [[NSUserDefaults standardUserDefaults] stringForKey:UD_userName_Str];

    //    判断是否登陆
    if (_userName)
    {
        _userInfoDic = [[NSUserDefaults standardUserDefaults ]dictionaryForKey:UD_userInfo_DIC];
        _petArr = [[NSUserDefaults standardUserDefaults]arrayForKey:UD_pet_Array];
    }
//        if (_headButton) {
//            _headButton = nil;
//        }
//        _headButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 60, 60)];
//        _headButton.backgroundColor = [UIColor whiteColor];
//        NSString *url = [dic objectForKey:@"userHeadMin"];
//        [_headButton setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
//        [_headButton addTarget:self action:@selector(uploadHeadAction) forControlEvents:UIControlEventTouchUpInside];
//        [_bgView addSubview:_headButton];
//        
//        //        白色背景图
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 25, 160, 35)];
//        view.backgroundColor = [UIColor whiteColor];
//        view.alpha = .7;
//        [_bgView addSubview:view];
//        
//        if (_usernameLabel ) {
//            _usernameLabel = nil;
//        }
//        _usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 25, 80, 20)];
//        _usernameLabel.textColor = [UIColor colorWithRed:0.9 green:0.52 blue:0.13 alpha:1];
//        _usernameLabel.font = [UIFont boldSystemFontOfSize:14];
//        [_bgView addSubview:_usernameLabel];
//        _usernameLabel.text = [dic objectForKey:@"userNickname"];
//        [_usernameLabel sizeToFit];
//        
//        if (_sexImageView) {
//            _sexImageView = nil;
//        }
//        _sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 25, 20, 17)];
//        if ([[dic objectForKey:@"userSex"] intValue] == 0) {
//            [_sexImageView setImage: [UIImage imageNamed:@"my_sex_man.png"]];
//        }else{
//            [_sexImageView setImage: [UIImage imageNamed:@"my_sex_woman.png"]];
//        }
//        [_bgView addSubview:_sexImageView];
//        _sexImageView.left = _usernameLabel.right + 5;
//        
//        //        普通图标
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20,15)];
//        imageView.image = [UIImage imageNamed:@"my_address.png"];
//        [view addSubview:imageView];
//        
//        if (_addressLabel) {
//            _addressLabel = nil;
//        }
//        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 45, 120, 15)];
//        _addressLabel.textColor = [UIColor colorWithRed:0.48 green:0.4 blue:0.09 alpha:1];
//        _addressLabel.font = [UIFont boldSystemFontOfSize:13];
//        [_bgView addSubview:_addressLabel];
//        _addressLabel.text = [[NSUserDefaults standardUserDefaults ]objectForKey:UD_nowPosition_Str];
//        _po( [[NSUserDefaults standardUserDefaults ]objectForKey:UD_nowPosition_Str]);
//        //        读取宠物信息
//        _petArr = [[NSUserDefaults standardUserDefaults]arrayForKey:UD_pet_Array];
//        
//    }
//    else
//    {//未登录
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( (ScreenWidth - 100)/2  , 0, 120, 50)];
//        view.backgroundColor = [UIColor whiteColor];
//        view.alpha = .7;
//        [_bgView addSubview:view];
//        
//        
//        //        登录和注册按钮
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 59, 50)];
//        [button setTitle:@"登录" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.tag = 100;
//        [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:button];
//        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(1 + 60, 0, 59, 50)];
//        [button1 setTitle:@"注册" forState:UIControlStateNormal];
//        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button1.tag = 101;
//        [button1 addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:button1];
//        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(59, 10, 2, 30)];
//        line.backgroundColor = [UIColor grayColor];
//        [view addSubview:line];
//    }
    [_tableView reloadData];

}


#pragma mark -
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

-(void)addPetAction:(UIButton *)button{
    [self.navigationController pushViewController:[[AddPetViewController alloc]initWithPetDic:nil] animated:YES];

}


#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *petDic = _petArr[indexPath.row];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
        [params setObject:[petDic objectForKey:@"petId"] forKey:@"petId"];
        [self showHudInBottom:@"删除中" autoHidden:NO];
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
                [self showHudInBottom:@"删除失败" autoHidden:YES];

                return ;
            }
            [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _po([error localizedDescription]);
            [self removeHUD];
            [self showHudInBottom:@"删除失败" autoHidden:YES];
        }];
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_userName) {
        if ( _petArr.count > 0 ) {
            if (indexPath.section == 1 ) {
                return YES;
            }
        }
    }
    return NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (_userName) {
                if (_petArr.count == 0 ) {
                    return 1;
                }else{
                    return _petArr.count;
                }
            }else{
                return [_noLoginNameArr count];
            }
            
        case 2:
            return [_noLoginNameArr count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    登陆了
    if (_userName) {
        if (indexPath.section == 0) {
            static NSString *userLoginIdentifier = @"userLoginIdentifier";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userLoginIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userLoginIdentifier];
//                头像
                _headButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 80, 80)];
                _headButton.tag = 1000;
                [_headButton addTarget:self action:@selector(uploadHeadAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_headButton];
//                用户名
                UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 25, 80, 20)];
                usernameLabel.textColor = [UIColor colorWithRed:0.9 green:0.52 blue:0.13 alpha:1];
                usernameLabel.tag = 1001;
                usernameLabel.font = [UIFont boldSystemFontOfSize:14];
                [cell.contentView  addSubview:usernameLabel];
//                性别
                UIImageView *sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 25, 20, 17)];
                sexImageView.tag = 1002;
                [cell.contentView addSubview:sexImageView];
//                地点
                UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 120, 15)];
                addressLabel.textColor = [UIColor colorWithRed:0.48 green:0.4 blue:0.09 alpha:1];
                addressLabel.tag = 1003;
                addressLabel.font = [UIFont boldSystemFontOfSize:13];
                [cell.contentView addSubview:addressLabel];
                
//                地点logo
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 50, 15,15)];
                imageView.image = [UIImage imageNamed:@"my_address.png"];
                [cell.contentView addSubview:imageView];
            }
//            头像
            NSString *url = [_userInfoDic objectForKey:@"userHeadMin"];
//            [_headButton setImageWithURL:[NSURL URLWithString:url] forState:
//            UIControlStateNormal];
            [_headButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:url]];
//          用户名
            UILabel *usernameLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 1001);
            usernameLabel.text = [_userInfoDic objectForKey:@"userNickname"];
            [usernameLabel sizeToFit];
//            性别
            UIImageView *sexImageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 1002);
            if ([[_userInfoDic objectForKey:@"userSex"] intValue] == 0) {
                [sexImageView setImage: [UIImage imageNamed:@"my_sex_man.png"]];
            }else{
                [sexImageView setImage: [UIImage imageNamed:@"my_sex_woman.png"]];
            }
            sexImageView.left = usernameLabel.right + 5;
            //                地点
            UILabel *addressLabel = (UILabel *)VIEWWITHTAG(cell.contentView, 1003);
            addressLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:UD_nowPosition_Str];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section == 1 ) {//宠物
//            有加号
            if (indexPath.row == 0 ) {
                static NSString *myFirstCellIdentifier = @"myFirstCellIdentifier";
                MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:myFirstCellIdentifier];
                if (cell == nil) {
                    cell = [[MyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myFirstCellIdentifier ];
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(250-14, 0, 44, 44)];
                    [button setImage:[UIImage imageNamed:@"my_addpet@2x.png"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(addPetAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                }

                UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
                UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
                //            尚未有宠物
                if (_petArr.count == 0 ) {
                    label.text = @"添加宠物";
                    imageView.image = [UIImage imageNamed:@"my_petlogo.png"];
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
                    cell = [[MyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier ];
                }
                
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
            label.text = _noLoginNameArr[indexPath.row];
            imageView.image = [UIImage imageNamed:_noLoginImageArr[indexPath.row]];
            return cell;

        }
    }//未登陆
    else{
        if (indexPath.section == 0 ) {
            static NSString *userNoLoginIdentifier = @"userNoLoginIdentifier";

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userNoLoginIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userNoLoginIdentifier];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
                imageView.image = [UIImage imageNamed:@"my_petlogo.png"];
                [cell.contentView addSubview:imageView];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(130, 50, 150, 20)];
                label.text = @"登陆后更精彩！";
                label.font = FONT(15);
                [cell.contentView addSubview:label];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString *noLoginIdentifier = @"noLoginIdentifier";
        MyViewCell *cell = (MyViewCell *)[tableView dequeueReusableCellWithIdentifier:noLoginIdentifier];
        if (cell == nil) {
            cell = [[MyViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noLoginIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 101);
        label.text = _noLoginNameArr[indexPath.row];
        UIImageView *imageView = (UIImageView *)VIEWWITHTAG(cell.contentView, 100);
        imageView.image = [UIImage imageNamed:_noLoginImageArr[indexPath.row]];
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_userName) {
        return 3;
    }
    return 2;
    
}
#pragma mark -
#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_userName) {
        if ( _petArr.count > 0 ) {
            if (indexPath.section == 1 ) {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    return UITableViewCellEditingStyleNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 120;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {//个人
        if (_userName) {
            [self.navigationController pushViewController:[[MyInfoViewController alloc]init] animated:YES];
        }else {
            [self.navigationController pushViewController:[[LoginViewController alloc] init]  animated:YES];
        }
    }else if(indexPath.section == 1 && _userName !=nil){//宠物
        [self.navigationController pushViewController:[[AddPetViewController alloc] initWithPetDic:(_petArr.count == 0 ? nil : _petArr[indexPath.row]) ] animated:YES];
    }else{
        if (!_userName) {
            [self.navigationController pushViewController:[[LoginViewController alloc] init]  animated:YES];
            return;
        }
        switch (indexPath.row) {
            case 0://我的宠友
                [self.navigationController pushViewController:[[MYFriendViewController alloc]init] animated:YES];
                break;
            case 1://我的问诊
                [self.navigationController pushViewController:[[MyAskViewController alloc]init] animated:YES];
                break;
            case 2://我的帖子
                [self.navigationController pushViewController:[[MyPostViewController alloc]init] animated:YES];
                break;
            case 3://我的回复
                [self.navigationController pushViewController:[[MyReplyViewController alloc] init] animated:YES];
                break;
            case 4://用户协议
                [self.navigationController pushViewController:[[AboutViewController alloc] initWithTitle: @"用户协议" andFileName:@"agreement"] animated:YES];
                break;
            case 5://关于我们
                [self.navigationController pushViewController:[[AboutViewController alloc] initWithTitle:@"关于我们" andFileName:@"about"] animated:YES];
                break;
            case 6:
                [self.navigationController pushViewController:[[SettingViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }
    
//    if (indexPath.section == 0 ) {
//        if (_userName) {
//            if (indexPath.section == 0) {
//                
//            }else if(indexPath.section == 1){
//                if (indexPath.row == 0) {
//                    
//                }else if(indexPath.row == 1){
//                    
//                }else{//个人资料
//                    
//                }
//            }
//        }else{
//            
//        }
//    }else if(indexPath.section == 1 ){
//        if (_userName) {
//            if (indexPath.section == 0) {
//                [self.navigationController pushViewController:[[AddPetViewController alloc] initWithPetDic:(_petArr.count == 0 ? nil : _petArr[indexPath.row]) ] animated:YES];
//            }else if(indexPath.section == 1){
//                if (indexPath.row == 0) {//我的问诊
//                    [self.navigationController pushViewController:[[MyAskViewController alloc]init] animated:YES];
//                }else if(indexPath.row == 1){//我的帖子
//                    [self.navigationController pushViewController:[[MyPostViewController alloc]init] animated:YES];
//                }else{//个人资料
//                    
//                    [self.navigationController pushViewController:[[MyInfoViewController alloc]init] animated:YES];
//                    
//                }
//            }
//        }
//    }
//    else{
//        if(_userName? indexPath.section == 2 :indexPath.section == 1){//打分
//            
//        }else if (_userName? indexPath.section == 3 :indexPath.section == 2){
//
//        }
//
//    }
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
    [self showHudInBottom:@"上传中。。"  autoHidden : NO];
    //    发送请求
    NSString *userMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str];
    [manager POST:[BASE_URL stringByAppendingPathComponent:URL_uploadUserImage_Post] parameters:@{@"userId":userMemberId} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        需要上传的图片
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"userHeadImage" fileName:@"userHead.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            NSString *newHeadImage = [[responseObject objectForKey:@"user"] objectForKey:@"userHeadMin"];
//            [_headButton setImageWithURL:[NSURL URLWithString:newHeadImage] forState:UIControlStateNormal placeholderImage:image];
            [_headButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:newHeadImage] placeholderImage:image];
            [self removeHUD];
            [self showHudInBottom:@"上传成功" autoHidden: NO];
            //            更新本地userdefaults
            NSDictionary *userDic = [responseObject objectForKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:UD_userInfo_DIC];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"上传失败" autoHidden: YES];
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

@end
