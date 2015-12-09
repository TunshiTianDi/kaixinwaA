//
//  QKHomeRequestTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/8.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKHomeRequestTool : NSObject
+ (void)postHomeResultSuccess:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)postHomeResultForRefreshSuccess:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
