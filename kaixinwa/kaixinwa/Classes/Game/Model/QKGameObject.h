//
//  QKGameObject.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKGameObject : NSObject
@property(nonatomic,copy)NSString * gameUrlStr;
@property(nonatomic,copy)NSString * gameImageName;
@property(nonatomic,copy)NSString * gameName;

-(instancetype)initWithGameImageName:(NSString *)imageName andGameUrl:(NSString *)gameUrlStr andGameName:(NSString *)gameName;
@end
