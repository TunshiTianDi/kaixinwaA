//
//  QKHomeData.h
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QKRadio;

@interface QKHomeData : NSObject

@property(nonatomic,strong)NSArray * video;

@property(nonatomic,strong)NSArray * game;
/** 轮播数组*/
@property(nonatomic,strong)NSArray * lunbo;

@property(nonatomic,strong)NSArray * goods;

@property(nonatomic,strong)QKRadio * radio;

@end
