//
//  QKMyShareObj.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKMyShareObj : NSObject

/** 分享标题*/
@property(nonatomic,copy)NSString * shareTitle;
/** 分享链接*/
@property(nonatomic,copy)NSString * shareUrl;
/** 分享图片url*/
@property(nonatomic,copy)NSString * imageUrl;
/** 分享的时间戳*/
@property(nonatomic,copy)NSString * shareTime;

@end
