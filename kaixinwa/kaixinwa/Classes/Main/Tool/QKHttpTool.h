//
//  QKHttpTool.h
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@interface QKHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
/** md5加密算法*/
+ (NSString *)md5HexDigest:(NSString *)url;

+ (void)postJSON:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

+(void)sendNickPicWithImage:(UIImage *)image params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
