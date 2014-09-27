//
//  PetKnowledgeViewController.h
//  宠信
//
//  Created by __ on 14-7-24.
//  Copyright (c) 2014年 zzw. All rights reserved.
//

#import "TenyeaBaseViewController.h"
/**
 宠物知识vc
 
 */
@interface PetKnowledgeViewController : TenyeaBaseViewController<UITableViewDataSource,UITableViewDelegate>

/**
 *  <#Description#>
 *
 *  @param type   <#type description#>
 *  @param kindId <#kindId description#>
 *  @param board  board 0  不推送新页面 1推送新页面
 *
 *  @return <#return value description#>
 */
-(id)initWithType:(NSString *)type KindId:(NSString *)kindId board :(int) board;
@end
