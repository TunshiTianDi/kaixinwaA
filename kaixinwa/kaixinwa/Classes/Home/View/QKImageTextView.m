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
        nameLabel.numberOfLines = 0;
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
    
    CGSize maxSize = CGSizeMake(self.imageView.width, 999);
    self.nameLabel.centerX = self.imageView.centerX;
    self.nameLabel.size =[self.nameLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nameLabel.font} context:nil].size;
    
//    self.nameLabel.size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.nameLabel.y = CGRectGetMaxY(self.imageView.frame)+QKCellMargin/2;
}

-(void)tapView{
    switch (self.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
//            DCLog(@"11111->%@->%@",self.game.gameurl,self.game.id_str);
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationToSkipGameWeb object:nil userInfo:@{GameKey : self.game.gameurl,@"id": self.game.id_str}];
            break;
        case 4:
        case 5:
        case 6:
        case 7:
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationToSkipTimeLimit object:nil userInfo:@{@"gid" : self.goods.gid}];
            break;
            
        default:
            break;
    }
}

@end
