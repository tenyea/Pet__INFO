//
//  PetClassificationViewController.h
//  宠信
//
//  Created by __ on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
/**
 宠物类别
*/
@interface PetClassificationViewController : TenyeaBaseViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *  初始化
 *
 *  @param type       <#type description#>
 *  @param secondType 是否有第二个页面
 *
 *  @return <#return value description#>
 */
-(id)initWithType:(NSString *)type secondType:(BOOL)secondType;
-(id)initWithType:(NSString *)type;
@end
