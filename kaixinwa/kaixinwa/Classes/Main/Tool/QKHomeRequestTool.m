//
//  QKHomeRequestTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/8.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKHomeRequestTool.h"
#import "QKHttpTool.h"
#import "QKDataBaseTool.h"
#import "AppDelegate.h"

#define QKHomeCacheFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"homeCache.data"]

@implementation QKHomeRequestTool
+ (void)postHomeResultSuccess:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    if([NSKeyedUnarchiver unarchiveObjectWithFile:QKHomeCacheFilepath]){
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithFile:QKHomeCacheFilepath];
        success(dic);
    }else{
        [QKHttpTool post:@"http://101.200.173.111/kaixinwa2.0/index.php/Kxwapi/Index/getHome" params:nil success:^(id responseObj) {
            if (success) {
                //归档
                [NSKeyedArchiver archiveRootObject:responseObj toFile:QKHomeCacheFilepath];
                success(responseObj);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

+ (void)postHomeResultForRefreshSuccess:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    [QKHttpTool post:@"http://101.200.173.111/kaixinwa2.0/index.php/Kxwapi/Index/getHome" params:nil success:^(id responseObj) {
        if (success) {
            [NSKeyedArchiver archiveRootObject:responseObj toFile:QKHomeCacheFilepath];
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
