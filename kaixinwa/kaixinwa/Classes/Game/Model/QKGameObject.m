//
//  QKGameObject.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameObject.h"

@implementation QKGameObject
-(instancetype)initWithGameImageName:(NSString *)imageName andGameUrl:(NSString *)gameUrlStr andGameName:(NSString *)gameName
{
    self = [super init];
    if (self != nil) {
        _gameImageName = imageName;
        _gameUrlStr = gameUrlStr;
        _gameName = gameName;
    }
    return self;
}
@end
