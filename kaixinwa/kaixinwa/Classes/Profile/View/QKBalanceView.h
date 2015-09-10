//
//  QKBalanceView.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QKBalanceView;

@protocol QKBalanceViewDelegate <NSObject>

@optional
- (void)balanceOnClickRecharge:(QKBalanceView *)balanceView;
- (void)balanceOnClickShopping:(QKBalanceView *)balanceView;
@end

@interface QKBalanceView : UIView
@property(nonatomic,weak)id<QKBalanceViewDelegate>delegate;
@property(nonatomic,weak)UILabel * peaCountLabel;
@end
