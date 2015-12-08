//
//  HMCommonSwitchItem.m
//  黑马微博
//
//  Created by apple on 14-7-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMCommonSwitchItem.h"

@implementation HMCommonSwitchItem
-(void)setOn:(BOOL)on
{
    _on = on;
    //存储数据
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:on forKey:self.title];
    [ud synchronize];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    self.on = [ud boolForKey:title];
    
}

@end
