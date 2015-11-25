//
//  QKProfileHVFrame.h
//  kaixinwa
//
//  Created by 张思源 on 15/11/24.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QKAccount.h"
#import "QKProfileViewFrame.h"

@interface QKProfileHVFrame : NSObject

@property(nonatomic,strong)QKProfileViewFrame * profileViewFrame;

@property(nonatomic,assign)CGRect balanceViewFrame;

@property(nonatomic,strong)QKAccount * account;

@property(nonatomic,assign)CGRect frame;
@end
