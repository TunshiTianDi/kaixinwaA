//
//  QKProfileHVFrame.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/24.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKProfileHVFrame.h"

@implementation QKProfileHVFrame
-(void)setAccount:(QKAccount *)account
{
    _account = account;
    
    QKProfileViewFrame * profileFrame = [[QKProfileViewFrame alloc]init];
    profileFrame.account = account;
    self.profileViewFrame = profileFrame;
    
    if (account) {
        [self setupBalanceViewFrame];
    }
    
    self.frame = account != nil ? CGRectMake(0, 0, QKScreenWidth, CGRectGetMaxY(self.balanceViewFrame)+QKCellMargin): CGRectMake(0, 0, QKScreenWidth, CGRectGetMaxY(self.profileViewFrame.frame)+QKCellMargin);
    
}

- (void)setupBalanceViewFrame
{
    CGFloat balanceViewX = 0;
    CGFloat balanceViewY = CGRectGetMaxY(self.profileViewFrame.frame) + QKCellMargin;
    CGFloat balanceViewW = QKScreenWidth;
    CGFloat balanceViewH = 44;
    self.balanceViewFrame = CGRectMake(balanceViewX , balanceViewY, balanceViewW, balanceViewH);
}
@end
