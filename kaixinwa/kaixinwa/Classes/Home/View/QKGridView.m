//
//  QKGridView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGridView.h"
#import "QKGoods.h"
#import "QKGame.h"
#import "QKBottomView.h"

@interface QKGridView()
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)UIButton * moreButton;
@property(nonatomic,weak)QKBottomView *bottomView;
@end

@implementation QKGridView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        //创建
        UILabel* titleLabel =[[UILabel alloc]init];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton * moreButton = [[UIButton alloc]init];
        [moreButton setTitle:@"显示更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:QKColor(167, 167, 167) forState:UIControlStateNormal];
        [moreButton setImage:[UIImage imageNamed:@"adjust"] forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        moreButton.backgroundColor = [UIColor yellowColor];
        [moreButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.moreButton = moreButton;
        [self addSubview:moreButton];
        
        QKBottomView *bottomView = [[QKBottomView alloc]init];
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setMoreBtnTag:(NSUInteger)moreBtnTag
{
    _moreBtnTag = moreBtnTag;
    self.moreButton.tag = moreBtnTag;
}

-(void)onClick:(UIButton*)button;
{
    switch (button.tag) {
        case 1:
            DCLog(@"play card");
            break;
        case 2:
            DCLog(@"play jungle");
            break;
        default:
            break;
    }
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    
    
    self.bottomView.items = items;
    

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
    
    self.bottomView.x = 0;
    self.bottomView.y = CGRectGetMaxY(self.titleLabel.frame)+ QKCellMargin;
    self.bottomView.width = self.width;
    self.bottomView.height = self.height - QKCellMargin * 2 - self.titleLabel.height- 2 * QKCellMargin;
    
}

@end
