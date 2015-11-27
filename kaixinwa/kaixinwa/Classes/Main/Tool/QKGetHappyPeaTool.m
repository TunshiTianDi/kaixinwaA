//
//  QKGetHappyPeaTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/18.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKGetHappyPeaTool.h"

@implementation QKGetHappyPeaTool
+(void)getHappyPeaNum
{
    NSDictionary * param = @{@"uid":[QKAccountTool readAccount].uid};
    [QKHttpTool post:GetHappyPeaInterface params:param success:^(id responseObj) {
        
        QKGetPeaCount * result = [QKGetPeaCount objectWithKeyValues:responseObj];
        NSInteger amount =[result.data.amount integerValue];
        NSString * amountStr = [NSString stringWithFormat:@"%ld",(long)amount];
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangePeaCount object:nil userInfo:@{@"ChangePeaCountKey":amountStr}];
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
    }];
}

+(void)getHappyPeaWithUpdate:(NSString *)task
{
    NSDictionary * param = @{@"uid":[QKAccountTool readAccount].uid,@"task":task};
    [QKHttpTool post:GetHappyPeaInterface params:param success:^(id responseObj) {
        QKGetPeaCount * result = [QKGetPeaCount objectWithKeyValues:responseObj];
        DCLog(@"%@-%@",task,responseObj);
        NSInteger amount =[result.data.amount integerValue];
        NSString * amountStr = [NSString stringWithFormat:@"%ld",(long)amount];
        //注册通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangePeaCount object:nil userInfo:@{@"ChangePeaCountKey":amountStr}];
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
    }];
}


@end
