//
//  QKRadioDetailView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKRadioDetailView.h"
#import "UIImageView+WebCache.h"

@interface QKRadioDetailView()
@property(nonatomic,weak)UIImageView * imageView;
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)UILabel * detailLabel;
@end

@implementation QKRadioDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc]init];
//        imageView.backgroundColor = [UIColor redColor];
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = QKGlobalBg.CGColor;
        imageView.layer.cornerRadius = 7.5;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel* titleLabel =[[UILabel alloc]init];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel * detailLabel = [[UILabel alloc]init];
        detailLabel.font = [UIFont systemFontOfSize:12];
        [detailLabel setTextColor:QKColor(167, 167, 167)];
        detailLabel.numberOfLines = 0;
        [self addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        
    }
    return self;
}
-(void)setRadio:(QKRadio *)radio
{
    _radio = radio;
    self.imageView.frame = CGRectMake(QKCellMargin, 0, 140 , 102);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:radio.radio_faceurl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    self.titleLabel.text = radio.radio_title;
    CGSize maxTagSize = CGSizeMake(QKScreenWidth - self.imageView.width - 4 * QKCellMargin , MAXFLOAT);
    self.titleLabel.x = QKCellMargin + self.imageView.width + 2 * QKCellMargin;
    self.titleLabel.y = self.imageView.y;
    self.titleLabel.size = [self.titleLabel.text boundingRectWithSize:maxTagSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    
    self.detailLabel.text = radio.radio_str;
    self.detailLabel.x = self.titleLabel.x;
    self.detailLabel.y = CGRectGetMaxY(self.titleLabel.frame) + QKCellMargin;
    self.detailLabel.size = [self.detailLabel.text boundingRectWithSize:maxTagSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.detailLabel.font} context:nil].size;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
