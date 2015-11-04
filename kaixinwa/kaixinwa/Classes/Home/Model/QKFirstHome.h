//
//  QKFirstHome.h
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKHomeData.h"

@interface QKFirstHome : NSObject
@property(nonatomic,copy)NSString * message;
@property(nonatomic,strong)QKHomeData * data;
@property(nonatomic,copy)NSString * code;

@end
