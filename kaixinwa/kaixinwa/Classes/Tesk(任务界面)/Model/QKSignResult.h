//
//  QKSignResult.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/17.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKSignData.h"

@interface QKSignResult : NSObject

@property(nonatomic,copy)NSString * message;
@property(nonatomic,strong)NSNumber * code;
@property(nonatomic,strong)QKSignData * data;

@end
