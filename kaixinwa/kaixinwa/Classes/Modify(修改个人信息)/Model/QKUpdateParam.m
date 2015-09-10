//
//  QKUpdateParam.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/6.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKUpdateParam.h"
#import "QKAccount.h"
#import "QKAccountTool.h"

@implementation QKUpdateParam
- (instancetype)init
{
    self = [super init];
    if (self) {
        QKAccount * account = [QKAccountTool readAccount];
        self.uid = account.uid;
        
    }
    return self;
}

+(QKUpdateParam *)param
{
    return [[self alloc]init];
}
@end
