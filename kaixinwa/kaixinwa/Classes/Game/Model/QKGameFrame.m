//
//  QKGameFrame.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameFrame.h"
#import "QKGameObject.h"
#import "QKGameDetailViewFrame.h"

@implementation QKGameFrame
-(void)setGameObject:(QKGameObject *)gameObject
{
    _gameObject = gameObject;
    
    QKGameDetailViewFrame * gameDetailViewFrame = [[QKGameDetailViewFrame alloc]init];
    gameDetailViewFrame.gameObject = gameObject;
    
    self.gameDetailFrame = gameDetailViewFrame;
    
    self.cellHeight = CGRectGetMaxY(self.gameDetailFrame.frame);
}
@end
