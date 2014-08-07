//
//  MyInfoViewController.m
//  宠信
//
//  Created by tenyea on 14-7-18.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "MyInfoViewController.h"
#import "PetNameAndVarietyViewController.h"
#import "PetSexViewController.h"
#import "UpdatePasswordVC.h"
#import "UIImageView+WebCache.h"
#import "DataCenter.h"
#import "AFHTTPRequestOperationManager.h"

#define headImageHeigh 70
#define time 1.5
@interface MyInfoViewController ()
{
    UITableView *_tableView;
    NSArray *_array;
    NSDictionary *_userDic ;
    
    UIImage *_headImage;
}
@end

@implementation MyInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _array = @[@"头像",@"昵称",@"性别",@"位置",@"邮箱",@"用户名",@"修改密码",@"推送消息",@"清除缓存",@""];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UD_userInfo_DIC];
    _userDic = [[NSDictionary alloc]initWithDictionary:dic];
    [[NSUserDefaults standardUserDefaults]setValue:_userDic forKey:UD_userInfo_temp_DIC];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20 - 1, 100- 1, 280 + 2, 44*5 + headImageHeigh + 2)];
    [self.view addSubview:bgView];
    
    self.title = @"个人设置";
    float heigh = 0.0;
    if ((44* ([_array count] - 1) + headImageHeigh)>ScreenHeight - 66 -49) {
        heigh = ScreenHeight - 66 - 49;
    }else{
        heigh = 44* ([_array count] - 1) + headImageHeigh;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, ScreenWidth , heigh) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _userDic = [[NSUserDefaults standardUserDefaults]objectForKey:UD_userInfo_temp_DIC];
    [_tableView reloadData];
}
#pragma mark -
#pragma mark Action
-(void)returnAction{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:UD_userInfo_temp_DIC];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [super returnAction];
}
//登出
-(void)logoutAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userInfo_DIC];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userID_Str];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_userName_Str];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_pet_Array];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
-(void)submitAction{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[_userDic objectForKey:@"userNickname"] forKey:@"userName"];
    [params setObject:[_userDic objectForKey:@"userId"] forKey:@"userId"];
    [params setObject:[_userDic objectForKey:@"userSex"] forKey:@"userSex"];
    
    //    提示图片上传中
    [self showHudInBottom:@"修改中。。"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:[BASE_URL stringByAppendingPathComponent:URL_updateUserInfo_Post] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (_headImage) {//图片存在
            //        需要上传的图片
            [formData appendPartWithFileData:UIImagePNGRepresentation(_headImage) name:@"userHeadImage" fileName:@"userHead.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            [self removeHUD];
            NSDictionary *userDic = [responseObject objectForKey:@"user"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userDic forKey:UD_userInfo_DIC];
            [user synchronize];
            [self showHudInBottom:@"修改成功"];
            [self performSelector:@selector(popVC) withObject:nil afterDelay:time];
        }else if([[responseObject objectForKey:@"code"] intValue]==1001){//失败
            [self removeHUD];
            [self showHudInBottom:@"修改失败"];
            [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
            return ;
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"修改失败"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
    }];
    
}
-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"马上照一张" otherButtonTitles:@"从手机相册选择", nil ];
            [as showInView:self.view];
        }
            break;
        case 1:
            [self.navigationController pushViewController:[[PetNameAndVarietyViewController alloc]initWithType:2 ] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[PetSexViewController alloc]initWithType:1] animated:YES];
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            [self.navigationController pushViewController:[[UpdatePasswordVC alloc]init] animated:YES];
            break;
        case 7://推送
            break;
        case 8:
            [[DataCenter sharedCenter] cleanCache];
            [tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case 9:
            [self logoutAction];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return headImageHeigh;
    }else{
        return 44;
    }
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < (_array.count - 1)) {
        
        static NSString *editUserInfoIdentifier = @"editUserInfoIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editUserInfoIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:editUserInfoIdentifier];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, 13, 0, 20)];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor grayColor];
            label.tag = 100;
            [cell.contentView addSubview:label];
        }
        cell.textLabel.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
        cell.textLabel.text = _array[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 3|| indexPath.row == 4 ||indexPath.row ==5 || indexPath.row > 6) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 100);
        
        if (indexPath.row == 8) {
            NSUInteger cacheSize = [[DataCenter sharedCenter] cacheSize];
            if (cacheSize < 1024)
            {
                label.text = [NSString stringWithFormat: @"%u B", cacheSize];
            }
            else if (cacheSize < 1024 * 1024)
            {
                label.text = [NSString stringWithFormat: @"%.2f KB", (cacheSize * 1.0f) / 1024];
            }
            else if (cacheSize < 1024 * 1024 * 1024)
            {
                label.text = [NSString stringWithFormat: @"%.2f MB", (cacheSize * 1.0f) / (1024 * 1024)];
            }
            else
            {
                label.text = [NSString stringWithFormat: @"%.2f GB", (cacheSize * 1.0f) / (1024 * 1024 * 1024)];
            }
        }
        else  if (indexPath.row == 0)
            {

                if (![ [_userDic objectForKey: @"userHeadMin"] isEqualToString:@""]) {
                    UIImageView *imageView = [[UIImageView alloc]init];
                    NSString *url = [_userDic objectForKey: @"userHeadMin"];
                    [imageView setImageWithURL:[NSURL URLWithString: url]];
                    cell.accessoryView = imageView;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
            }
        else if(indexPath.row == 1)//昵称
        {
            if (![ [_userDic objectForKey:@"userNickname"] isEqualToString:@""]) {
                label.text = [_userDic objectForKey:@"userNickname"];
            }

        }
        else if(indexPath.row == 2)//性别
        {
            int sexTag = [[_userDic objectForKey:@"userSex"] intValue];
            if (sexTag == 0) {
                label.text =  @"男";
            }else{
                label.text =  @"女";
            }
        }
        else if(indexPath.row == 3)//位置
        {
            label.text = [[NSUserDefaults standardUserDefaults] stringForKey:UD_nowPosition_Str];
        }
        else if(indexPath.row == 4)//邮箱
        {
            if (![ [_userDic objectForKey:@"userEmail"] isEqualToString:@""]) {
                label.text = [_userDic objectForKey:@"userEmail"];
            }
        }
        else if(indexPath.row == 5)//用户名
        {
            if (![ [_userDic objectForKey:@"userName"] isEqualToString:@""]) {
                label.text = [_userDic objectForKey:@"userName"];
            }
        }
        
        [label sizeToFit];
        label.right = 240;
        
        return cell;
    }else{
        static NSString *logoutIdentifier = @"logoutIdentifier" ;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
        if ( cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutIdentifier];
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth - 30, 44 - 10)];
            button.backgroundColor = [UIColor redColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 8;
            [button setTitle:@"退出登录" forState:UIControlStateNormal ];
            [button addTarget: self  action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
        
        return cell;
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
    UIImage  * petImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    petImage = [self scaleToSize:petImage size:CGSizeMake(200, 200)];
    _headImage = petImage;
    //    如果是照相的图片。保存到本地
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//保存到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(petImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath: indexPath];
        petImage = [self scaleToSize:petImage size:CGSizeMake(50, 50)];
        cell.accessoryView = [[UIImageView alloc]initWithImage:petImage];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
#pragma mark -
#pragma mark Method
//保存成功或失败
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        _po(@"保存失败");
    }else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath: indexPath];
        image = [self scaleToSize:image size:CGSizeMake(50, 50)];
        cell.accessoryView = [[UIImageView alloc]initWithImage:image];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
@end
