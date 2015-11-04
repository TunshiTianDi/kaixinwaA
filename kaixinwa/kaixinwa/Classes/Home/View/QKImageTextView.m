//
//  QKImageTextView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKImageTextView.h"

@implementation QKImageTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tap];
        UIImageView * imageView = [[UIImageView alloc]init];
        self.imageView = imageView;
        [self addSubview:imageView];
        UILabel * nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont systemFontOfSize:11];
        [nameLabel setTextColor:QKColor(157, 157, 157)];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.width;
    
    
    self.nameLabel.centerX = self.imageView.centerX;
    self.nameLabel.size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.nameLabel.y = self.height- QKCellMargin/2 - self.nameLabel.height;
}

-(void)tapView{
    DCLog(@"%ld",(long)self.tag);
}

@end
