//
//  QKProfileViewFrame.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/24.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKProfileViewFrame.h"
#import "QKAccount.h"

@implementation QKProfileViewFrame
-(void)setAccount:(QKAccount *)account
{
    _account = account;
    
    
    //头像的frame
    CGFloat iconW = 80;
    CGFloat iconH = iconW;
    CGFloat iconX = (QKScreenWidth - iconW)/2;
    CGFloat iconY = QKCellMargin;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    //头像背景的frame
    CGFloat iconBGW = 85;
    CGFloat iconBGH = iconBGW;
    CGFloat iconBGX = (QKScreenWidth - iconBGW)/2;
    CGFloat iconBGY = QKCellMargin - 2.5;
    self.iconBGFrame = CGRectMake(iconBGX, iconBGY, iconBGW, iconBGH);
    //头像装饰
    CGFloat iconCameraW = 20;
    CGFloat iconCameraH = 20;
    CGFloat iconCameraX = iconBGX + iconBGW - iconCameraW - 0.5 * QKCellMargin;
    CGFloat iconCameraY =  iconBGY + iconBGH - iconCameraH - 0.4 * QKCellMargin;
    self.iconCameraFrame = account != nil ? CGRectMake(iconCameraX, iconCameraY, iconCameraW, iconCameraH) : CGRectZero;
    if (account) {
        self.templeLabelFrame = CGRectZero;
        //昵称
        CGSize nameLabelSize;
        
        if ([account.user_name isEqualToString:@""]||account.user_name == nil) {
            nameLabelSize = [@"点击头像设置昵称" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        }else{
            nameLabelSize = [account.user_name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        }
        CGFloat nameLabelX = (QKScreenWidth - nameLabelSize.width)/2;
        CGFloat nameLabelY = CGRectGetMaxY(self.iconBGFrame) + QKCellMargin;
        self.nameLabelFrame = CGRectMake(nameLabelX, nameLabelY, nameLabelSize.width, nameLabelSize.height);
        //个性签名
        CGSize signatureLabelSize;
        if([account.signature isEqualToString:@""]||account.signature== nil){
             signatureLabelSize = [@"未设置" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        }else{
             signatureLabelSize = [account.signature sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        }
        CGFloat signatureLabelX = (QKScreenWidth - signatureLabelSize.width)/2;
        CGFloat signatureLabelY = CGRectGetMaxY(self.nameLabelFrame) + QKCellMargin/2;
        self.signatureLabelFrame = CGRectMake(signatureLabelX, signatureLabelY, signatureLabelSize.width, signatureLabelSize.height);
        //学校
        CGSize schoolLabelSize;
        if ([account.school isEqualToString:@""]||account.school== nil) {
            schoolLabelSize = [@"未设置" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        }else{
            schoolLabelSize = [account.school sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        }
        CGFloat schoolLabelX = (QKScreenWidth - schoolLabelSize.width) / 2;
        CGFloat schoolLabelY = CGRectGetMaxY(self.signatureLabelFrame) + QKCellMargin/2;
        self.schoolLabelFrame = CGRectMake(schoolLabelX, schoolLabelY, schoolLabelSize.width, schoolLabelSize.height);
        
        //自身的frame
        self.frame = CGRectMake(0, 0, QKScreenWidth, CGRectGetMaxY(self.schoolLabelFrame)+QKCellMargin);
    }else{
        NSString * str = @"登录/注册";
        CGSize templeLabelSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        CGFloat templeLabelX = (QKScreenWidth - templeLabelSize.width)/2;
        CGFloat templeLabelY = CGRectGetMaxY(self.iconBGFrame) + QKCellMargin;
        self.templeLabelFrame = CGRectMake(templeLabelX, templeLabelY, templeLabelSize.width, templeLabelSize.height);
        
        self.frame = CGRectMake(0, 0, QKScreenWidth, CGRectGetMaxY(self.templeLabelFrame)+QKCellMargin);
    }
    
}
@end
