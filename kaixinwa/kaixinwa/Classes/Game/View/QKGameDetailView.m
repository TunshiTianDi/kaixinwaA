//
//  QKGameDetailView.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameDetailView.h"
@interface QKGameDetailView()

@property(nonatomic,weak)UIImageView * gameIcon;

@property(nonatomic,weak)UILabel * gameTitle;

@property(nonatomic,weak)UIButton * gameStartButton;

@property(nonatomic,copy)NSString * gameUrlStr;
@end

@implementation QKGameDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"shuruyanzhengmakuang"];
        //创建控件
        UIImageView * gameIcon = [[UIImageView alloc]init];
        self.gameIcon = gameIcon;
        [self addSubview: gameIcon];
        
        UILabel * gameTitle = [[UILabel alloc]init];
        gameTitle.font = [UIFont systemFontOfSize:15];
        self.gameTitle = gameTitle;
        [self addSubview:gameTitle];
        
        
        UIButton * gameStartButton = [[UIButton alloc]init];
        [gameStartButton setBackgroundImage:[UIImage imageNamed:@"green-frame"] forState:UIControlStateNormal];
        [gameStartButton setTitle:@"开始游戏" forState:UIControlStateNormal];
        [gameStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gameStartButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [gameStartButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.gameStartButton = gameStartButton;
        [self addSubview:gameStartButton];
    }
    return self;
}

-(void)onClick:(UIButton *)button
{
//    DCLog(@"点击开始%@",self.gameUrlStr);
    [[NSNotificationCenter defaultCenter] postNotificationName:BeginGameNotifacation object:nil userInfo:@{@"urlStr" : self.gameUrlStr}];
}

-(void)setGameDetailFrame:(QKGameDetailViewFrame *)gameDetailFrame
{
    _gameDetailFrame = gameDetailFrame;
    QKGameObject * gameObject = gameDetailFrame.gameObject;
    self.frame = gameDetailFrame.frame;
    
    self.gameIcon.image = [UIImage imageNamed:gameObject.gameImageName];
    self.gameIcon.frame = gameDetailFrame.gameIconFrame;
    
    self.gameTitle.text = gameObject.gameName;
    self.gameTitle.frame = gameDetailFrame.gameTitleFrame;
    
    self.gameUrlStr = gameObject.gameUrlStr;
    self.gameStartButton.frame = gameDetailFrame.gameButtonFrame;
}
@end
