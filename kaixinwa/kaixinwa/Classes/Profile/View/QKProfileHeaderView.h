//
//  QKProfileHeaderView.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKProfileHVFrame.h"
@class QKProfileView,QKBalanceView;

@interface QKProfileHeaderView : UIImageView
/** 个人信息*/
@property(nonatomic,weak)QKProfileView * profileView;
/** 账户余额信息*/
@property(nonatomic,weak)QKBalanceView * balanceView;

@property(nonatomic,strong)QKProfileHVFrame * profileHVFrame;
@end
