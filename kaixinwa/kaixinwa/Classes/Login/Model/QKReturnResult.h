//
//  QKReturnResult.h
//  kaixinwa
//
//  Created by 张思源 on 15/6/30.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKLoginData.h"

@interface QKReturnResult : NSObject
@property(nonatomic,copy)NSString * message;
@property(nonatomic,strong)NSNumber * code;
@property(nonatomic,strong)QKLoginData * data;
@end
