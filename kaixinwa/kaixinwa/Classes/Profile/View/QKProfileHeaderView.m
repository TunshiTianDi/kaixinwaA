//
//  QKProfileHeaderView.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKProfileHeaderView.h"
#import "QKProfileView.h"
#import "QKBalanceView.h"
#import "QKAccountTool.h"
#import "QKAccount.h"

@implementation QKProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = QKGlobalBg;
        //加载个人页面
        QKProfileView * profileView = [[QKProfileView alloc]init];
        [self addSubview:profileView];
        self.profileView = profileView;
        QKAccount * account = [QKAccountTool readAccount];
        if (account) {
            //显示余额
            QKBalanceView * balanceView = [[QKBalanceView alloc]init];
            [self addSubview:balanceView];
            self.balanceView = balanceView;
        }
        
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //设置头像信息view的frame
//    CGFloat profileViewX = 0;
//    CGFloat profileViewY = 0;
//    self.profileView.frame = CGRectMake(profileViewX, profileViewY, self.profileView.width, self.profileView.height);
//    //设置账户信息的frame
//    CGFloat balanceViewX = profileViewX;
//    CGFloat balanceViewY = profileViewY + self.profileView.height + 14;
//    CGFloat balanceViewH = 44;
//    CGFloat balanceViewW = self.profileView.width;
//    self.balanceView.frame = CGRectMake(balanceViewX, balanceViewY, balanceViewW, balanceViewH);
    //设置自身的frame
//    self.height = CGRectGetMaxY(self.balanceView.frame);
    
}

-(void)setProfileHVFrame:(QKProfileHVFrame *)profileHVFrame
{
    _profileHVFrame = profileHVFrame;
    
    self.profileView.profileViewFrame = profileHVFrame.profileViewFrame;
    
    self.balanceView.frame = profileHVFrame.balanceViewFrame;
}
@end
