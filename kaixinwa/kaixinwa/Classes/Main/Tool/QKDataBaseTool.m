//
//  QKDataBaseTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#define PATH_OF_Task_Sqlite    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"task.sqlite"]

#import "QKDataBaseTool.h"
#import "QKMyShareObj.h"
#import "QKMessageContent.h"

@implementation QKDataBaseTool

+(void)cleanAllTaskMessage
{
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_Task_Sqlite];
    if ([db open]) {
        NSString * sql = @"delete from task";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            DCLog(@"error to delete db data");
        } else {
            DCLog(@"成功删除数据");
        }
        [db close];
    }
}

//创建任务表
+(void)creatTableForTask
{
    NSString * path = PATH_OF_Task_Sqlite;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open]) {
            
            NSString * sql2 = @"CREATE TABLE 'Task' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'title' TEXT, 'detailText' TEXT)";
            BOOL res = [db executeUpdate:sql2];
            if (!res) {
                DCLog(@"error when creating db table");
            } else {
                DCLog(@"成功建表");
            }
            [db close];
        } else {
            DCLog(@"error when open db");
        }
    }
}

//插入任务数据
+(void)insertInTaskTableWithTitle:(NSString *)title andDetailText:(NSString *)detail {
    
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_Task_Sqlite];
    if ([db open]) {
        NSString * sql = @"insert into task (title, detailText) values(?, ?)";
        
        BOOL res = [db executeUpdate:sql, title, detail];
        if (!res) {
            DCLog(@"error to insert data");
        } else {
            DCLog(@"插入成功");
            
        }
        [db close];
    }
}

+(NSMutableArray *)lookupTaskTableContent
{
    NSMutableArray * array = [NSMutableArray array];
    FMDatabase * db =[FMDatabase databaseWithPath:PATH_OF_Task_Sqlite];
    if ([db open]) {
        NSString * sql = @"select * from task order by id desc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString * title = [rs stringForColumn:@"title"];
            NSString * url = [rs stringForColumn:@"detailText"];
            QKMessageContent * messageContent = [[QKMessageContent alloc]init];
            messageContent.title = title;
            messageContent.detailText = url;
            [array addObject:messageContent];
        }
        [db close];
    }
    return array;
}


@end
