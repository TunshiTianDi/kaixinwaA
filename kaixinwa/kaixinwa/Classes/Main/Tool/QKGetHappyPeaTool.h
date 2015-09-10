//
//  QKGetHappyPeaTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/18.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKHttpTool.h"
#import "QKGetPeaCount.h"
#import "MJExtension.h"
#import "QKAccountTool.h"
#import "QKAccount.h"

@interface QKGetHappyPeaTool : NSObject
+(void)getHappyPeaNum;

//更新个人信息获得开心豆
+(void)getHappyPeaWithUpdate:(NSString *)task;

@end
