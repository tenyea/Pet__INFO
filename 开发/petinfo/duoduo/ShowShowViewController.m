//
//  ShowShowViewController.m
//  宠信
//
//  Created by __ on 14-8-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ShowShowViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface ShowShowViewController ()
{
UIImage *_petImageTemp; //用于上传
}
@end

@implementation ShowShowViewController
@synthesize textView;
@synthesize addImageButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"晒一晒";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [textView becomeFirstResponder];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [button addTarget: self  action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:@"发帖" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)submitAction{

    if (!_petImageTemp) {
        [self showHudInBottom:@"请加入图片"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
        return;
        
    }
    
    
    if ([textView.text isEqualToString:@""]) {
        [self showHudInBottom:@"说点什么吧"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
        return;
        
    }
    NSString *userMemberId = [[NSUserDefaults standardUserDefaults] objectForKey:UD_userID_Str];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:userMemberId forKey:@"userId"];
    [params setObject:textView.text forKey:@"petPhotoText"];
   
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //    提示图片上传中
  //  [self showHudInBottom:@"上传中。。"];
    //    发送请求
    [manager POST:[BASE_URL stringByAppendingPathComponent:URL_Add_Pet_Photo] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
            //        需要上传的图片
            [formData appendPartWithFileData:UIImagePNGRepresentation(_petImageTemp) name:@"userHeadImage" fileName:@"userHead.png" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue]==0 ) {//成功
            [self removeHUD];
            [self showHudInBottom:@"提交成功"];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1];
        }
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _po([error localizedDescription]);
        [self removeHUD];
        [self showHudInBottom:@"提交失败"];
        [self performSelector:@selector(removeHUD) withObject:nil afterDelay:1];
    }];

    
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addImage:(id)sender {
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle: nil otherButtonTitles:@"马上照一张",@"从手机相册选择", nil ];
    [as showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"用户点击的是第%d个按钮",buttonIndex);
//    if (actionSheet.tag == 1000) {//选择宠物
//        if (buttonIndex == _petArr.count) {
//            //        取消
//        }else {
//            [_petSelectButton setTitle:[_petArr[buttonIndex] objectForKey:@"petName"] forState:UIControlStateNormal ];
//            _selectPetId = [_petArr[buttonIndex] objectForKey:@"petId"];
//        }
//    }else{//选择宠物照片
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
    
//}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    关闭navigation
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    //    获取图片
    UIImage  * image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    image = [self scaleToSize:image size:CGSizeMake(200, 200)];
    _petImageTemp = image;
    //    如果是照相的图片。保存到本地
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//保存到本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    }else{
        image = [self scaleToSize:image size:CGSizeMake(50, 50)];
        [addImageButton setImage:image forState:UIControlStateNormal];
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
        image = [self scaleToSize:image size:CGSizeMake(50, 50)];
        [addImageButton setImage:image forState:UIControlStateNormal];
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
