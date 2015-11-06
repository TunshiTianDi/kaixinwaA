//
//  QKAnimationView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKAnimationView.h"
#import "QKBottomAnimationView.h"

@interface QKAnimationView()
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)QKBottomAnimationView * bottomAnimationView;
@property(nonatomic,weak)UIImageView * dividerView;
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
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = QKCellMargin;
    self.titleLabel.y = QKCellMargin;
    self.titleLabel.size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
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
