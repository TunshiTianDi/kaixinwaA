//
//  QKAccountTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QKAccount;
@interface QKAccountTool : NSObject

/** 储存账号*/
+ (void)save:(QKAccount *)account;

/** 读取账号*/
+ (QKAccount *)readAccount;

/** 删除账号*/
+ (void)deleteAccount;
@end
