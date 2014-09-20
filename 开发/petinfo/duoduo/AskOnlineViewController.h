//
//  AskOnlineViewController.h
//  宠信
//
//  Created by tenyea on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"

@interface AskOnlineViewController : TenyeaBaseViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    UITextView *textView;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

-(id)initWithDoctorId:(NSString *)DoctorId andDocName :(NSString *)DocName ;


@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *docNameLabel;
- (IBAction)petSelectAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *petSelectButton;

//选择图片
- (IBAction)selectImageAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *petImageButton;

@end
