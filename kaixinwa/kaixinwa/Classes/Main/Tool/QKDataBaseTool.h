//
//  QKDataBaseTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface QKDataBaseTool : NSObject
//创建share表
+(void)creatTableForShare;
//往分享表内添加数据
+(void)insertInShareTableWithTitle:(NSString*)title andShareUrl:(NSString *)shareUrl andImageUrl:(NSString *)imageUrl andCreatTime:(NSString*)creatTime;
//插入数据往任务表
+(void)insertInTaskTableWithTitle:(NSString *)title andDetailText:(NSString *)detail;
//获取分享表内容
+(NSMutableArray *)lookupTableContent;
//创建task表
+(void)creatTableForTask;
//查询task表
+(NSMutableArray *)lookupTaskTableContent;
//清空分享表内数据
+(void)cleanAll;
//清空任务表内数据
+(void)cleanAllTaskMessage;
@end
