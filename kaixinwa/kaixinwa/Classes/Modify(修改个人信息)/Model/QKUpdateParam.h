//
//  QKUpdateParam.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/6.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKUpdateParam : NSObject
/** 要更新的数据*/
@property(nonatomic,copy)NSString * update_date;

@property(nonatomic,strong)NSNumber * uid;

/** 要更新的数据类型 
 1、昵称
 2、签名
 3、weixin
 4、qq号
 5、地址
 6、学校
 */
@property(nonatomic,strong)NSString * update_type;

+(QKUpdateParam *)param;

@end
