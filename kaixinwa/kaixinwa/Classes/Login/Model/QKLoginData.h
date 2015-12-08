//
//  QKLoginData.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/14.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKLoginData : NSObject

/** md5密码*/
@property(nonatomic,copy)NSString * password;
/** uid*/
@property(nonatomic,strong)NSNumber * uid;
/** 设备号*/
@property(nonatomic,copy)NSString * equipment_id;
/** 创建时间*/
@property(nonatomic,copy)NSString * create_time;
/** 手机号码*/
@property(nonatomic,copy)NSString * telephone;
/** 客户端类型*/
@property(nonatomic,strong)NSNumber * client_type;
/** 用户类型*/
@property(nonatomic,strong)NSNumber * user_type;
/** upkey*/
@property(nonatomic,copy)NSString * upkey;
/** 登录时间*/
@property(nonatomic,copy)NSString * login_time;
/** lasttime*/
@property(nonatomic,copy)NSString * lasttime;
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
/** header*/
@property(nonatomic,copy)NSString * header;
@end
