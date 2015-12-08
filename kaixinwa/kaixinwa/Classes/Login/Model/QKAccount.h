//
//  QKAccount.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKAccount : NSObject<NSCoding>

/** 创建时间 */
@property (nonatomic, copy) NSString *created_time;
/** 手机号码 */
@property (nonatomic, copy) NSString * phoneNum;
/** 服务器返回uid */
@property (nonatomic, strong) NSNumber * uid;
/** upkey*/
@property (nonatomic,copy) NSString * upkey;
/** 客户端类型*/
@property(nonatomic,strong)NSNumber * client_type;
/** 用户类型*/
@property(nonatomic,strong)NSNumber * user_type;
/** 签到返回的时间*/
@property(nonatomic,copy)NSString * lasttime;
/** 签到返回的时间(NSDate)*/
@property(nonatomic,strong)NSDate * lasttime_date;
/** 学校*/
@property(nonatomic,copy)NSString * school;
/** 绑定微信*/
@property(nonatomic,copy)NSString * weixin;
/** 昵称*/
@property(nonatomic,copy)NSString * user_name;
/** 个性签名*/
@property(nonatomic,copy)NSString * signature;
/** 地址*/
@property(nonatomic,copy)NSString * address;
/** 绑定qq号*/
@property(nonatomic,copy)NSString * qq;
/** token*/
@property(nonatomic,copy)NSString * token;
/** 头像URL*/
@property(nonatomic,copy)NSString * header;
@end
