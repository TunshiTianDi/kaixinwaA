//
//  QKControllerTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKControllerTool : NSObject
/**
 *  选择根控制器
 */
+ (void)chooseRootViewController;
/**
    选择进入控制器
 */
+ (void)chooseRootViewControllerWithIndex:(NSUInteger)index;
@end
