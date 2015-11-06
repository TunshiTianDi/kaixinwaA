//
//  QKImageTextView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKImageTextView.h"
#import "UIImageView+WebCache.h"
@interface QKImageTextView()
@property(nonatomic,weak)UILabel * nameLabel;
@property(nonatomic,weak)UIImageView * imageView;
@end

@implementation QKImageTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tap];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = QKGlobalBg.CGColor;
        imageView.layer.cornerRadius = 7.5;
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

-(void)setGame:(QKGame *)game
{
    _game = game;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:game.faceurl] placeholderImage:nil];
    self.nameLabel.text = game.title;

}
-(void)setGoods:(QKGoods *)goods
{
    _goods = goods;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:goods.goods_faceurl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = goods.goods_name;

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
    self.nameLabel.y = CGRectGetMaxY(self.imageView.frame)+QKCellMargin/2;
}

-(void)tapView{
    DCLog(@"%ld",(long)self.tag);
    switch (self.tag) {
        case 0:
            DCLog(@"11110->%@",self.game.gameurl);
            break;
        case 1:
            DCLog(@"11111->%@",self.game.gameurl);
            break;
        case 2:
            DCLog(@"11112->%@",self.game.gameurl);
            break;
        case 3:
            DCLog(@"11113->%@",self.game.gameurl);
            break;
        case 4:
            DCLog(@"11114->");
            break;
        case 5:
            DCLog(@"11115->");
            break;
        case 6:
            DCLog(@"11116->");
            break;
        case 7:
            DCLog(@"11117->");
            break;
            
        default:
            break;
    }
    
}

@end
