//
//  QKNotFoundNetView.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/20.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKNotFoundNetView.h"
@interface QKNotFoundNetView()
@property(nonatomic,weak)UIImageView * imageView;
@property(nonatomic,weak)UILabel * label;
@property(nonatomic,weak)UIButton * button;
@end
@implementation QKNotFoundNetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView * imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"not_found"]];
        [self addSubview:imageView];
        self.imageView = imageView;
        UILabel * label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"无法连接网络";
        label.textColor = QKColor(211, 211, 211);
        [self addSubview:label];
        self.label = label;
        UIButton * button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"reload_button"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
        
    }
    return self;
}

-(void)onClick
{
    if ([self.delegate respondsToSelector:@selector(clickReloadButton:)]) {
        [self.delegate clickReloadButton:self];
    }
}
-(void)layoutSubviews
{
    
    self.imageView.width = 150;
    self.imageView.height = 150;
    self.imageView.x = (QKScreenWidth - self.imageView.width)/2;
    self.imageView.y = self.height * 0.3;
    
    
    self.label.size = [self.label.text sizeWithAttributes:@{NSFontAttributeName : self.label.font}];
    self.label.centerX = self.centerX;
    self.label.y = CGRectGetMaxY(self.imageView.frame) + QKCellMargin;
    
    self.button.size = CGSizeMake(100,30);
    self.button.centerX = self.centerX;
    self.button.y = CGRectGetMaxY(self.label.frame) + 3 * QKCellMargin;
}

-(void)showInView:(UIView *)view
{
    [view bringSubviewToFront:self];
}
-(void)hideInOtherView:(UIView *)view
{
    [self.superview bringSubviewToFront:view];
    [self removeFromSuperview];
}
@end
