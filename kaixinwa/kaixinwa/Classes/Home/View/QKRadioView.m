//
//  QKRadioView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKRadioView.h"
#import "QKRadioDetailView.h"

@interface QKRadioView()
@property(nonatomic,weak)UILabel * titleLabel;
@property(nonatomic,weak)UIButton * moreButton;
@property(nonatomic,weak)QKRadioDetailView * radioDetailView;
@property(nonatomic,weak)UIImageView * dividerView;
@end

@implementation QKRadioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //1.创建标题label
        UILabel * titleLabel = [[UILabel alloc]init];
        [titleLabel setTextColor:[UIColor blackColor]];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton * moreButton = [[UIButton alloc]init];
        [moreButton setTitle:@"显示更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:QKColor(167, 167, 167) forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//        moreButton.backgroundColor = [UIColor yellowColor];
        [moreButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        self.moreButton = moreButton;
        [self addSubview:moreButton];
        
        QKRadioDetailView * radioDetailView = [[QKRadioDetailView alloc]init];
//        radioDetailView.backgroundColor = [UIColor cyanColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [radioDetailView addGestureRecognizer:tap];
        
        [self addSubview:radioDetailView];
        self.radioDetailView = radioDetailView;
        
        //分隔线
        UIImageView * dividerView = [[UIImageView alloc]init];
        dividerView.backgroundColor = QKGlobalBg;
        [self addSubview:dividerView];
        self.dividerView = dividerView;
        
    }
    return self;
}

-(void)onClick:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationToSkipRadioMore object:nil userInfo:@{@"url":@"http://101.200.173.111/kaixinwa2.0/phone.php/Radio/index"}];
}
-(void)tapView:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifacationToSkipRadio object:nil userInfo:@{@"id":self.radio.id_str}];
}

-(void)setRadio:(QKRadio *)radio
{
    _radio = radio;
    self.radioDetailView.radio = radio;
    
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
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
    
    self.radioDetailView.x = 0;
    self.radioDetailView.y = CGRectGetMaxY(self.titleLabel.frame) + QKCellMargin;
    self.radioDetailView.width = self.width;
    self.radioDetailView.height = self.height - QKCellMargin * 2 - self.titleLabel.height- 2 * QKCellMargin;
    
    self.dividerView.x = QKDoubleMargin;
    self.dividerView.height = 1;
    self.dividerView.width = QKScreenWidth - self.dividerView.x;
    self.dividerView.y = self.height - self.dividerView.height;
}

@end
