//
//  QKImageTextMiddleView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKImageTextMiddleView.h"
#import "UIImageView+WebCache.h"
@interface QKImageTextMiddleView()
@property(nonatomic,weak)UILabel * nameLabel;
@property(nonatomic,weak)UIImageView * imageView;
@end

@implementation QKImageTextMiddleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
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
-(void)setVideo:(QKVideo *)video
{
    _video = video;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:video.type_face_url] placeholderImage:nil];
    self.nameLabel.text = video.type_name;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize nlSize = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.width - nlSize.height-QKCellMargin;
    
    
    self.nameLabel.centerX = self.imageView.centerX;
    self.nameLabel.size = nlSize;
    self.nameLabel.y = self.height- QKCellMargin/2 - self.nameLabel.height;
}

-(void)tapView{
    DCLog(@"%ld",(long)self.tag);
}

@end
