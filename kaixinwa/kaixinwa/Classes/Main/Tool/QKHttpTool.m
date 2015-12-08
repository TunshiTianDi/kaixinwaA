//
//  QKHttpTool.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKHttpTool.h"
#import "QKAccountTool.h"

@implementation QKHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];

}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    AFJSONResponseSerializer *afjrs = [AFJSONResponseSerializer serializerWithReadingOptions:1];
//    afjrs.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"text/plain",@"text/json", @"application/json", @"text/javascript", nil];
//    mgr.responseSerializer = afjrs;
    AFJSONResponseSerializer *responseSerializer=[AFJSONResponseSerializer serializer];
    AFHTTPRequestSerializer *resquertSerializer=[AFHTTPRequestSerializer serializer];
    [mgr setRequestSerializer:resquertSerializer];
    [mgr setResponseSerializer:responseSerializer];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json", @"application/json", @"text/javascript", nil];
    
    
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)postJSON:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializer=[AFJSONResponseSerializer serializer];
    AFHTTPRequestSerializer *resquertSerializer=[AFHTTPRequestSerializer serializer];
    [mgr setRequestSerializer:resquertSerializer];
    [mgr setResponseSerializer:responseSerializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json", @"application/json", @"text/javascript", nil];
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+(void)sendNickPicWithImage:(UIImage *)image params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json", @"application/json", @"text/javascript", nil];
    
        // 3.发送POST请求
        [mgr POST:@"http://101.200.173.111/kaixinwa2.0/kxwaapi.php/User/upload_header" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *data=UIImagePNGRepresentation(image);
            // 拼接文件参数
            [formData appendPartWithFileData:data name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        } success:^(AFHTTPRequestOperation *operation, id responseObj) {
            if (success) {

                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
                success(dict);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    
    

}

/** md5加密算法*/
+ (NSString *)md5HexDigest:(NSString *)url
{
    const char *original_str = [url UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
