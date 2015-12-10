//
//  QKGameFrame.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QKGameDetailViewFrame,QKGameObject;
@interface QKGameFrame : NSObject

@property(nonatomic,strong)QKGameDetailViewFrame * gameDetailFrame;

@property(nonatomic,strong)QKGameObject * gameObject;

@property(nonatomic,assign)CGFloat cellHeight;
@end
