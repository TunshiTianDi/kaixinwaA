//
//  QKGameDetailViewFrame.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKGameObject.h"

@interface QKGameDetailViewFrame : NSObject

/** icon */
@property (nonatomic, assign) CGRect gameIconFrame;
/** title */
@property (nonatomic, assign) CGRect gameTitleFrame;
/** 按钮 */
@property (nonatomic, assign) CGRect gameButtonFrame;

@property(nonatomic,assign)CGRect frame;

@property(nonatomic,strong)QKGameObject * gameObject;

@end
