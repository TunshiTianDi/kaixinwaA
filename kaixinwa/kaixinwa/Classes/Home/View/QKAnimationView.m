//
//  QKAnimationView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKAnimationView.h"
#import "QKBottomAnimationView.h"
#import "QKMoreButton.h"

@interface QKAnimationView()
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)QKBottomAnimationView * bottomAnimationView;
@property(nonatomic,weak)UIImageView * dividerView;
@property(nonatomic,weak)QKMoreButton *moreButton;
@end

@implementation QKAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //创建
        UILabel* titleLabel =[[UILabel alloc]init];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //右侧按钮
        QKMoreButton * moreButton = [[QKMoreButton alloc]init];
        [moreButton setTitle:@"显示更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:QKColor(167, 167, 167) forState:UIControlStateNormal];
        [moreButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [moreButton setImage:[UIImage imageNamed:@"arrow_right_highlighted"] forState:UIControlStateHighlighted];
        //        moreButton.backgroundColor = [UIColor yellowColor];
        [moreButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.moreButton = moreButton;
        [self addSubview:moreButton];
        
        //创建底部3个视图
        QKBottomAnimationView * bottomAnimationView = [[QKBottomAnimationView alloc]init];
        [self addSubview:bottomAnimationView];
        self.bottomAnimationView = bottomAnimationView;
        
        //分隔线
        UIImageView * dividerView = [[UIImageView alloc]init];
        dividerView.backgroundColor = QKGlobalBg;
        [self addSubview:dividerView];
        self.dividerView = dividerView;
        
    }
    return self;
}
-(void)setItems:(NSArray *)items
{
    _items = items;
    self.bottomAnimationView.items = items;
}
-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = title;
    
}

-(void)onClick:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationToSkipAnimation object:nil userInfo:@{@"url":@"http://101.200.173.111/kaixinwa2.0/video.php"}];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = QKCellMargin;
    self.titleLabel.y = QKCellMargin;
    self.titleLabel.size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.moreButton.width = 100;
    self.moreButton.height = 40;
    self.moreButton.x = self.width -self.moreButton.width - QKCellMargin;
    self.moreButton.centerY = self.titleLabel.centerY;
    
    self.bottomAnimationView.x = 0;
    self.bottomAnimationView.y = CGRectGetMaxY(self.titleLabel.frame)+ QKCellMargin;
    self.bottomAnimationView.width = self.width;
    self.bottomAnimationView.height = self.height - QKCellMargin * 2 - self.titleLabel.height- 2 * QKCellMargin;
    
    self.dividerView.x = QKDoubleMargin;
    self.dividerView.height = 1;
    self.dividerView.width = QKScreenWidth - self.dividerView.x;
    self.dividerView.y = self.height - self.dividerView.height;
}

@end
