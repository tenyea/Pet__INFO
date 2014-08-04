//
//  AddPetViewController.m
//  宠信
//
//  Created by tenyea on 14-7-16.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "AddPetViewController.h"
#import "PetNameAndVarietyViewController.h"
#import "PetBirthdayViewController.h"
#import "PetSexViewController.h"
#import "PetKindViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "PetModel.h"
#define headImageHeigh 70
#define petNameIsNullMessage @"昵称不能为空"
#define time 1.5
@interface AddPetViewController ()
{
    UITableView *_tableView;
    NSArray *_array;
    NSDictionary *_petDIC;
    NSArray *_kindArr;
    
    UIImage *_petImage;
    BOOL _isAddPet;
}
@end

@implementation AddPetViewController
-(id)initWithPetDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
//        如果存在，则说明是修改,不存在则为新添
        if (dic) {
            _petDIC = dic;
            self.title = @"修改宠物信息";
            _isAddPet = NO;
        }else{
            self.title = @"添加宠物";
            _isAddPet = YES;
            _petDIC = [[NSDictionary alloc]initWithObjectsAndKeys:
                       @"",@"petId",
                       @"",@"petName",
                       @"",@"petHeadImage",
                       @"",@"petBirthday",
                       @"",@"petSex",
                       @"",@"petKind",
                       @"",@"petVariety",nil];
        }
        self.model = [[PetModel alloc]initWithDataDic:_petDIC];

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _array = @[@"头像",@"昵称",@"生日",@"性别",@"种类",@"品种"];
    _kindArr = @[@"狗狗",@"猫猫",@"小宠",@"水族",@"其他"];
    [[NSUserDefaults standardUserDefaults]setValue:_petDIC  forKey:UD_petInfo_temp_PetModel];
    [[NSUserDefaults standardUserDefaults]synchronize];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20 - 1, 100- 1, 280 + 2, 44*5 + headImageHeigh + 2)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 13;
    [self.view addSubview:bgView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 100, 280 , 44*5 + headImageHeigh) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 13;
    [self.view addSubview: _tableView];
 
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.model = [[PetModel alloc]initWithDataDic:[[NSUserDefaults standardUserDefaults] objectForKey:UD_petInfo_temp_PetModel]];
    [_tableView reloadData];
}
#pragma mark -
#pragma mark Action
//提交
-(void)submitAction{
//添加宠物信息
    if ([self.model.petName  isEqualToString:@""]) {
        [self showHudInBottom:petNameIsNullMessage];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:2];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject: [[NSUserDefaults standardUserDefaults] stringForKey:UD_userID_Str] forKey:@"userId"];
    [params setObject:_model.petName forKey:@"petName"];
    if ([_model.petSex intValue] == 0) {
        [params setObject:@(0) forKey:@"petSex"];
        
    }else{
        [params setObject:_model.petSex forKey:@"petSex"];
    }
    if ([_model.petKind intValue] == 0) {
        [params setObject:@(0) forKey:@"petKind"];
    }else{
        [params setObject:_model.petKind forKey:@"petKind"];
        
    }
    
    if (![_model.petVariety isEqualToString:@""]) {
        [params setObject:_model.petVariety forKey:@"petVariety"];
    }
    if (![_model.petBirthday isEqualToString:@""]) {
        [params setObject:_model.petBirthday forKey:@"petBirthday"];
    }
    
    //    修改宠物
    if (!_isAddPet) {
        int petId = [_model.petId intValue];
        
        [params setObject:[NSString stringWithFormat:@"%d",petId] forKey:@"petId"];
    }
    //    提示图片上传中
    [self showHudInBottom:@"上传中。。"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:[BASE_URL stringByAppendingPathComponent:URL_addPetInfo_Post] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (_petImage) {//图片存在
            //        需要上传的图片
            [formData appendPartWithFileData:UIImagePNGRepresentation(_petImage) name:@"petHeadImage" fileName:@"petHead.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            [self removeHUD];
            NSArray *petArr = [responseObject objectForKey:@"pet"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:UD_pet_Array];
            [user setObject:petArr forKey:UD_pet_Array];
            [user synchronize];
            if (_isAddPet) {
                [self showHudInBottom:@"添加成功"];
            }else{
                [self showHudInBottom:@"修改成功"];
            }
            [self performSelector:@selector(popVC) withObject:nil afterDelay:time];
        }else if([[responseObject objectForKey:@"code"] intValue]==1001){//失败
            [self removeHUD];
            if (_isAddPet) {
                [self showHudInBottom:@"添加失败"];
            }else{
                [self showHudInBottom:@"修改失败"];
            }
            [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
            return ;
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        if (_isAddPet) {
            [self showHudInBottom:@"添加失败"];
        }else{
            [self showHudInBottom:@"修改失败"];
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
    }];

    
}
-(void)popVC {
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
            [self.navigationController pushViewController:[[PetNameAndVarietyViewController alloc]initWithType:0 ] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[PetBirthdayViewController alloc ]init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[PetSexViewController alloc]initWithType:0] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[[PetKindViewController alloc]init] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[[PetNameAndVarietyViewController alloc]initWithType:1 ] animated:YES];
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
    static NSString *addPetIdentifier = @"addPetIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addPetIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addPetIdentifier];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, 13, 0, 20)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor grayColor];
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    cell.textLabel.text = _array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *label = (UILabel *)VIEWWITHTAG(cell.contentView, 100);

    if (indexPath.row == 0)
    {

        if (![_model.petHeadImage isEqualToString:@""]) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setImageWithURL:[NSURL URLWithString:self.model.petHeadImage]];
            cell.accessoryView = imageView;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else if(indexPath.row == 1)//昵称
    {
        if (![self.model.petName isEqualToString:@""]) {
            label.text = self.model.petName;
        }

    }
    else if(indexPath.row == 2)//生日
    {
        if (![self.model.petBirthday isEqualToString:@""]) {
            label.text = self.model.petBirthday;
        }
    }
    else if(indexPath.row == 3)//性别
    {
        if ([self.model.petSex intValue] == 1 ) {
                label.text = @"母";
        }else{
            label.text = @"公";
        }
    }
    else if(indexPath.row == 4)//种类
    {
            label.text = _kindArr[[self.model.petKind intValue]];
    }
    else if(indexPath.row == 5)//品种
    {
        label.text = self.model.petVariety;
    }
    
    [label sizeToFit];
    label.right = 240;
    
    return cell;
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
    petImage = [self scaleToSize:petImage size:CGSizeMake(60, 60)];
    //    如果是照相的图片。保存到本地
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//保存到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(petImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath: indexPath];
        cell.accessoryView = [[UIImageView alloc]initWithImage:petImage];
        _petImage = petImage;
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
        cell.accessoryView = [[UIImageView alloc]initWithImage:image];
        _petImage = image;
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
