//
//  QKLocation.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/22.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKLocation : NSObject

@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;

@end
