//
//  QKHomeData.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKHomeData.h"
#import "QKRadio.h"
#import "QKGame.h"
#import "QKVideo.h"
#import "QKLunbo.h"
#import "QKGoods.h"
#import "MJExtension.h"

@implementation QKHomeData
-(NSDictionary *)objectClassInArray
{
    return @{@"video": [QKVideo class], @"game": [QKGame class],@"lunbo" : [QKLunbo class], @"goods": [QKGoods class]};
}
@end
