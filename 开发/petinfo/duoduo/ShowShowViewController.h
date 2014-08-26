//
//  ShowShowViewController.h
//  宠信
//
//  Created by __ on 14-8-11.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
/// 嗮萌宠，上传图片描述等
@interface ShowShowViewController : TenyeaBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
- (IBAction)addImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addImageButton;

@end
