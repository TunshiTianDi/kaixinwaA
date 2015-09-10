//
//  QKCheckString.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/15.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKCheckString : NSObject
/** 判断手机号*/
+ (BOOL) checkMobile:(NSString *)mobile;

/** 匹配用户密码6-18位数字和字母组合*/
+ (BOOL)checkPassword:(NSString *) password;
@end
