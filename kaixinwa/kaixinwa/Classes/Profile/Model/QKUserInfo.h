//
//  QKUserInfo.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKUserInfo : NSObject
/** string 	友好显示名称 */
@property (nonatomic, copy) NSString *name;

/** string 	用户头像地址 */
@property (nonatomic, copy) NSString *profile_image_url;

/** string 学校信息*/
@property (nonatomic, copy) NSString * schoolInfo;

/** string 个性签名*/
@property (nonatomic, copy) NSString * signature;
@end
