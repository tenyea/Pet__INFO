//
//  ShowPetCell.m
//  宠信
//
//  Created by __ on 14-7-22.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "ShowPetCell.h"

@implementation ShowPetCell
{
    
    UIImageView *praiseImageView1;
    UIImageView *praiseImageView2;
    UIImageView *praiseImageView3;
    UIImageView *praiseImageView4;
    UIImageView *praiseImageView5;
}
@synthesize praiseLabel1,praiseLabel2,praiseLabel3,praiseLabel4,praiseLabel5;
@synthesize transparentView1,transparentView2,transparentView3,transparentView4,transparentView5;
@synthesize imageView1,imageView2,imageView3,imageView4,imageView5;
- (void)awakeFromNib
{
    [super awakeFromNib];
   // [self _init];
}
-(void)_init{
    praiseImageView1=[[UIImageView alloc]init];
    praiseImageView1.frame=CGRectMake(60, 10, 15, 15);
    praiseImageView1.image=[UIImage imageNamed:@"story_red_heart.png"];
    [transparentView1 addSubview:praiseImageView1];
    praiseLabel1=[[UILabel alloc]init];
    praiseLabel1.frame=CGRectMake(70, 4, 42, 21);
    praiseLabel1.textColor=[UIColor whiteColor];
    [transparentView1 addSubview:praiseLabel1];
    praiseLabel1.font=[UIFont fontWithName:nil size:10];
   // praiseLabel1.text=@"11";
    [praiseLabel1 sizeToFit];
    CGSize titleSize1 = [praiseLabel1.text sizeWithFont:praiseLabel1.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    praiseLabel1.top=12;
    praiseLabel1.right=105;
    praiseImageView1.left=105-titleSize1.width-20;
    
    praiseImageView2=[[UIImageView alloc]init];
    praiseImageView2.frame=CGRectMake(60, 10, 15, 15);
    praiseImageView2.image=[UIImage imageNamed:@"story_red_heart.png"];
    [transparentView2 addSubview:praiseImageView2];
    praiseLabel2=[[UILabel alloc]init];
    praiseLabel2.frame=CGRectMake(70, 4, 42, 21);
    praiseLabel2.textColor=[UIColor whiteColor];
    [transparentView2 addSubview:praiseLabel2];
    praiseLabel2.font=[UIFont fontWithName:nil size:10];
  //  praiseLabel2.text=@"1111";
    [praiseLabel2 sizeToFit];
    CGSize titleSize2 = [praiseLabel2.text sizeWithFont:praiseLabel2.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    praiseLabel2.top=12;
    praiseLabel2.right=105;
    praiseImageView2.left=105-titleSize2.width-20;
    
    
    praiseImageView3=[[UIImageView alloc]init];
    praiseImageView3.frame=CGRectMake(60, 10, 15, 15);
    praiseImageView3.image=[UIImage imageNamed:@"story_red_heart.png"];
    [transparentView3 addSubview:praiseImageView3];
    praiseLabel3=[[UILabel alloc]init];
    praiseLabel3.frame=CGRectMake(70, 4, 42, 21);
    praiseLabel3.textColor=[UIColor whiteColor];
    [transparentView3 addSubview:praiseLabel3];
    praiseLabel3.font=[UIFont fontWithName:nil size:10];
  //  praiseLabel3.text=@"1111111";
    [praiseLabel3 sizeToFit];
    CGSize titleSize3 = [praiseLabel3.text sizeWithFont:praiseLabel3.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    praiseLabel3.top=12;
    praiseLabel3.right=105;
    praiseImageView3.left=105-titleSize3.width-20;
    
    praiseImageView4=[[UIImageView alloc]init];
    praiseImageView4.frame=CGRectMake(60, 10, 15, 15);
    praiseImageView4.image=[UIImage imageNamed:@"story_red_heart.png"];
    [transparentView4 addSubview:praiseImageView4];
    praiseLabel4=[[UILabel alloc]init];
    praiseLabel4.frame=CGRectMake(70, 4, 42, 21);
    praiseLabel4.textColor=[UIColor whiteColor];
    [transparentView4 addSubview:praiseLabel4];
    praiseLabel4.font=[UIFont fontWithName:nil size:10];
  //  praiseLabel4.text=@"111111111";
    [praiseLabel4 sizeToFit];
    CGSize titleSize4 = [praiseLabel4.text sizeWithFont:praiseLabel4.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    praiseLabel4.top=12;
    praiseLabel4.right=155;
    praiseImageView4.left=155-titleSize4.width-20;
    
    praiseImageView5=[[UIImageView alloc]init];
    praiseImageView5.frame=CGRectMake(60, 10, 15, 15);
    praiseImageView5.image=[UIImage imageNamed:@"story_red_heart.png"];
    [transparentView5 addSubview:praiseImageView5];
    praiseLabel5=[[UILabel alloc]init];
    praiseLabel5.frame=CGRectMake(70, 4, 42, 21);
    praiseLabel5.textColor=[UIColor whiteColor];
    [transparentView5 addSubview:praiseLabel5];
    praiseLabel5.font=[UIFont fontWithName:nil size:10];
 //   praiseLabel5.text=@"111111111111";
    [praiseLabel5 sizeToFit];
    CGSize titleSize5 = [praiseLabel5.text sizeWithFont:praiseLabel5.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    praiseLabel5.top=12;
    praiseLabel5.right=155;
    praiseImageView5.left=155-titleSize5.width-20;
    
   
    
}



@end
