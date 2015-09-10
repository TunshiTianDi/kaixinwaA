//
//  QKGetPeaCount.h
//  HappyFrogAnswer
//
//  Created by 张思源 on 15/8/10.
//  Copyright (c) 2015年 张思源. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKPeaCountData.h"

@interface QKGetPeaCount : NSObject
@property(nonatomic,strong)QKPeaCountData * data;
@property(nonatomic,copy)NSString * message;
@property(nonatomic,strong)NSNumber * code;
@end
