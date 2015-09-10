//
//  QKShareDetailView.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKShareDetailView.h"
#import "UIImageView+WebCache.h"

@interface QKShareDetailView()
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)UIImageView * shareImageView;
@end

@implementation QKShareDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"share-2"];
        UIImageView * shareImageView = [[UIImageView alloc]init];
        [self addSubview:shareImageView];
        self.shareImageView = shareImageView;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}
-(void)setMyShare:(QKMyShareObj *)myShare
{
    _myShare = myShare;
    [self.shareImageView sd_setImageWithURL:[NSURL URLWithString:myShare.imageUrl] placeholderImage:[UIImage imageNamed:@"share-1"]];
    self.titleLabel.text = myShare.shareTitle;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.shareImageView.x = 5;
    self.shareImageView.size = CGSizeMake(44, 44);
    self.shareImageView.y = (self.height - self.shareImageView.height)/2;
    
    self.titleLabel.x = CGRectGetMaxX(self.shareImageView.frame) + QKCellMargin;
    self.titleLabel.size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    self.titleLabel.y = (self.height - self.titleLabel.height)/2;
}

@end
