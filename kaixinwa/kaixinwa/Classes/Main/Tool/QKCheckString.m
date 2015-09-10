//
//  QKCheckString.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/15.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKCheckString.h"

@implementation QKCheckString

+ (BOOL) checkMobile:(NSString *)mobile
{
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex =@"^((13[0-9])|(147)|(15[^4,\\D])|(177)|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)checkPassword:(NSString *) password
{
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    //匹配6-16位数字或字母
    NSString * pattern = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
@end
