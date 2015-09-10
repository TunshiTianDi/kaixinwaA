//
//  QKAccountTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKAccountTool.h"
#import "QKAccount.h"

#define QKAccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation QKAccountTool
+ (void)save:(QKAccount *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:QKAccountFilepath];
}

+ (QKAccount *)readAccount
{
    // 读取帐号
    
    QKAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:QKAccountFilepath];
    return account;
}

+ (void)deleteAccount
{
    QKAccount * account = [self readAccount];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:QKAccountFilepath error:nil];
    account = nil;
    
}


@end
