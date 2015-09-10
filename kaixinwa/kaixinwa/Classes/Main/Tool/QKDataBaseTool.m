//
//  QKDataBaseTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//
#define PATH_OF_Share_Sqlite    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"share.sqlite"]
#define PATH_OF_Task_Sqlite    [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"task.sqlite"]

#import "QKDataBaseTool.h"
#import "QKMyShareObj.h"
#import "QKMessageContent.h"

@implementation QKDataBaseTool
+(void)cleanAll
{
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_Share_Sqlite];
    if ([db open]) {
        NSString * sql = @"delete from share";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            DCLog(@"error to delete db data");
        } else {
            DCLog(@"成功删除数据");
        }
        [db close];
    }
}
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
//创建分享表
+(void)creatTableForShare
{
    NSString * path = PATH_OF_Share_Sqlite;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'Share' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'title' TEXT, 'shareurl' TEXT,'imageurl' TEXT,'creattime', TEXT)";
            BOOL res = [db executeUpdate:sql];
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

//插入分享数据
+(void)insertInShareTableWithTitle:(NSString *)title andShareUrl:(NSString *)shareUrl andImageUrl:(NSString *)imageUrl andCreatTime:(NSString *)creatTime{
    
    FMDatabase * db = [FMDatabase databaseWithPath:PATH_OF_Share_Sqlite];
    if ([db open]) {
        NSString * sql = @"insert into share (title, shareurl, imageurl, creattime) values(?, ?, ?, ?) ";
       
        BOOL res = [db executeUpdate:sql, title, shareUrl ,imageUrl ,creatTime];
        if (!res) {
            DCLog(@"error to insert data");
        } else {
            DCLog(@"插入成功");
            
        }
        [db close];
    }
}
+(NSMutableArray *)lookupTableContent
{
    NSMutableArray * array = [NSMutableArray array];
    FMDatabase * db =[FMDatabase databaseWithPath:PATH_OF_Share_Sqlite];
    if ([db open]) {
        NSString * sql = @"select * from share order by id desc";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
//            int userId = [rs intForColumn:@"id"];
            NSString * title = [rs stringForColumn:@"title"];
            NSString * url = [rs stringForColumn:@"shareurl"];
            NSString * imgUrl = [rs stringForColumn:@"imageUrl"];
            NSString * creatTime = [rs stringForColumn:@"creattime"];
//            DCLog(@"user id = %d, title = %@, url = %@, imgUrl = %@, creat_t = %@", userId, title, url ,imgUrl ,creatTime);
            QKMyShareObj * myShare = [[QKMyShareObj alloc]init];
            myShare.shareTitle = title;
            myShare.shareUrl = url;
            myShare.imageUrl = imgUrl;
            myShare.shareTime = creatTime;
            [array addObject:myShare];
        }
        [db close];
    }
    return array;
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
