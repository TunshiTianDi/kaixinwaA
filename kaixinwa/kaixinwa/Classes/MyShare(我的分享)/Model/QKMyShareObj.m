//
//  QKMyShareObj.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKMyShareObj.h"
#import "NSDate+MJ.h"

@implementation QKMyShareObj

-(NSString *)shareTime
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"MM月dd日";
    NSDate * date =[NSDate dateWithTimeIntervalSince1970:[_shareTime doubleValue]];
    if([date isToday]){
        return @"今天";
    }else{
        return [fmt stringFromDate:date];
    }
}

@end
