//
//  QKUploadIconTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/2.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKUploadIconTool : NSObject
/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称

@end
