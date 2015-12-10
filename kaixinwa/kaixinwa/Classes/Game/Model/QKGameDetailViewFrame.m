//
//  QKGameDetailViewFrame.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameDetailViewFrame.h"

@implementation QKGameDetailViewFrame
-(void)setGameObject:(QKGameObject *)gameObject
{
    _gameObject = gameObject;
    
    CGFloat iconX = QKCellMargin;
    CGFloat iconY = QKCellMargin;
    CGFloat iconW = 74;
    CGFloat iconH = 74;
    self.gameIconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGSize titleSize = [gameObject.gameName sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    CGFloat titleX = CGRectGetMaxX(self.gameIconFrame) + QKCellMargin;
    CGFloat titleY = iconY;
    self.gameTitleFrame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    CGFloat myX = QKCellMargin;
    CGFloat myY = QKCellMargin;
    CGFloat myW = QKScreenWidth - 2 * QKCellMargin;
    CGFloat myH = iconH + 2 * QKCellMargin;
    self.frame = CGRectMake(myX, myY, myW, myH);
    
    CGFloat btnW = 70;
    CGFloat btnH = 40;
    CGFloat btnX = myW - btnW - QKCellMargin;
    CGFloat btnY = (myH - btnH)/2;
    self.gameButtonFrame = CGRectMake(btnX, btnY, btnW, btnH);
}
@end
