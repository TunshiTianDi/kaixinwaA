//
//  QKGameCell.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameCell.h"
#import "QKGameDetailView.h"
@interface QKGameCell()
@property(nonatomic,weak)QKGameDetailView * backgroundImageView;

@end

@implementation QKGameCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"GameCell";
    QKGameCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QKGameCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        QKGameDetailView * backgroundImageView = [[QKGameDetailView alloc]init];
        self.backgroundImageView = backgroundImageView;
        [self addSubview:backgroundImageView];
        
    }
    return self;
}
-(void)setGameFrame:(QKGameFrame *)gameFrame
{
    _gameFrame = gameFrame;
    

    self.backgroundImageView.gameDetailFrame = gameFrame.gameDetailFrame;
    
}

@end
