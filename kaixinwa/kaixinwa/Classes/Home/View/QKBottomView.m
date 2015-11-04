//
//  QKBottomView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKBottomView.h"
#import "QKImageTextView.h"
#import "QKGame.h"
#import "QKGoods.h"
#import "UIImageView+WebCache.h"
@implementation QKBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)setItems:(NSArray *)items{
    _items = items;
    for (int i = 0; i<items.count; i++) {
        QKImageTextView * itView = [[QKImageTextView alloc]init];
        
        if ([items[i] isKindOfClass:[QKGame class]]) {
            itView.tag = i;
            QKGame * game = items[i];
            [itView.imageView sd_setImageWithURL:[NSURL URLWithString:game.faceurl] placeholderImage:nil];
            itView.nameLabel.text = game.title;
        }else{
            itView.tag = i + 4;
            QKGoods * good = items[i];
            [itView.imageView sd_setImageWithURL:[NSURL URLWithString:good.goods_faceurl] placeholderImage:nil];
            itView.nameLabel.text = good.goods_name;
        }
        [self addSubview:itView];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < self.subviews.count; i++) {
        QKImageTextView * itView = self.subviews[i];
        itView.width = (self.width- 5 * QKCellMargin)/4;
        itView.height = self.height;
        itView.x = i * (itView.width + QKCellMargin) + QKCellMargin;
        itView.y = 0;
    }
}

@end
