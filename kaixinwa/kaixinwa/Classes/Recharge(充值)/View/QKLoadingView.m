//
//  QKLoadingView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/27.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKLoadingView.h"
@interface QKLoadingView()
@property(nonatomic,weak)UIActivityIndicatorView * aiv;
@property(nonatomic,weak)UILabel * explainLabel;
@end

@implementation QKLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.3;
        
        UIActivityIndicatorView * aiv = [[UIActivityIndicatorView alloc]init];
        [aiv startAnimating];
        aiv.hidesWhenStopped = YES;
        self.aiv = aiv;
        [self addSubview:aiv];
        UILabel * explainLabel = [[UILabel alloc]init];
        explainLabel.text = @"请求中...";
        explainLabel.textColor = [UIColor greenColor];
//        explainLabel.backgroundColor = [UIColor redColor];
        explainLabel.font = [UIFont systemFontOfSize:15];
        self.explainLabel = explainLabel;
        [self addSubview:explainLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.aiv.x = 60;
    self.aiv.y = 100;
    self.aiv.size = CGSizeMake(50, 50);
    
    
    
    self.explainLabel.y = CGRectGetMaxY(self.aiv.frame) + QKCellMargin;
    self.explainLabel.size = [self.explainLabel.text sizeWithAttributes:@{NSFontAttributeName : self.explainLabel.font}];
    self.explainLabel.x = self.aiv.centerX-self.explainLabel.width/2;
}

-(void)hideView
{
    [self.aiv stopAnimating];
    [self removeFromSuperview];
}

-(void)showInView:(UIView*)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
}
@end
