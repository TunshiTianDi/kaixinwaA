//
//  QKBalanceView.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKBalanceView.h"


#define QKMargin 10
#define QKUImargin 5
@interface QKBalanceView()
@property(nonatomic,weak)UILabel * showBalanceLabel;

@property(nonatomic,weak)UIImageView * icon;
@property(nonatomic,weak)UIButton * rechargeBtn;
@property(nonatomic,weak)UIButton * shoppingBtn;
@property(nonatomic,weak)UILabel * swLabel;
@end

@implementation QKBalanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //创建图片
        UIImageView * icon = [[UIImageView alloc]init];
        icon.image = [UIImage imageNamed:@"happy_beans_icon"];
        [self addSubview:icon];
        self.icon = icon;
        //创建label
        UILabel * showBalanceLabel = [[UILabel alloc]init];
        showBalanceLabel.font = [UIFont systemFontOfSize:14];
        showBalanceLabel.tintColor = [UIColor blackColor];
        showBalanceLabel.text = @"拥有";
        [self addSubview:showBalanceLabel];
        self.showBalanceLabel = showBalanceLabel;
        //创建开心豆数量lable
        UILabel * peaCountLabel = [[UILabel alloc]init];
        peaCountLabel.font = [UIFont systemFontOfSize:14];
        [peaCountLabel setTextColor:QKColor(232, 168, 39)];
        [self addSubview:peaCountLabel];
        self.peaCountLabel = peaCountLabel;
        //创建lable
        UILabel * swLabel = [[UILabel alloc]init];
        swLabel.font = [UIFont systemFontOfSize:14];
        swLabel.text = @"开心豆";
        [self addSubview:swLabel];
        self.swLabel = swLabel;
        //创建去充值按钮
        UIButton * rechargeBtn = [[UIButton alloc]init];
        rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rechargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
        [rechargeBtn setBackgroundImage:[UIImage imageNamed:@"chongzhiweidianji"] forState:UIControlStateNormal];
        [rechargeBtn setBackgroundImage:[UIImage imageNamed:@"chongzhidianji"] forState:UIControlStateHighlighted];
        [rechargeBtn addTarget:self action:@selector(clickRecharge:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rechargeBtn];
        self.rechargeBtn = rechargeBtn;
        
        //创建去商城按钮
        UIButton * shoppingBtn = [[UIButton alloc]init];
        shoppingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shoppingBtn setTitle:@"去商城" forState:UIControlStateNormal];
        [shoppingBtn setBackgroundImage:[UIImage imageNamed:@"chongzhiweidianji"] forState:UIControlStateNormal];
        [shoppingBtn setBackgroundImage:[UIImage imageNamed:@"chongzhidianji"] forState:UIControlStateHighlighted];
        [shoppingBtn addTarget:self action:@selector(clickShopping:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shoppingBtn];
        self.shoppingBtn = shoppingBtn;
        
        //改变开心豆数量
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePeaCount:) name:ChangePeaCount object:nil];
        
    }
    return self;
}
#pragma mark - 通知方法
-(void)changePeaCount:(NSNotification*)noti
{
    self.peaCountLabel.size = [noti.userInfo[@"ChangePeaCountKey"] sizeWithAttributes:@{NSFontAttributeName:self.peaCountLabel.font}];
    self.peaCountLabel.text = noti.userInfo[@"ChangePeaCountKey"];
}

#pragma mark - 内部方法
-(void)clickRecharge:(UIButton *)sender
{
    [self beginDelegate];
}
-(void)clickShopping:(UIButton *)sender
{
    [self beginDelegate1];
}

-(void)beginDelegate
{
    if ([self.delegate respondsToSelector:@selector(balanceOnClickRecharge:)]) {
        [self.delegate balanceOnClickRecharge:self];
    }
}
-(void)beginDelegate1
{
    if([self.delegate respondsToSelector:@selector(balanceOnClickShopping:)]){
        [self.delegate balanceOnClickShopping:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片frame
    CGFloat iconX;
    if(IS_IPHONE_6){
        iconX = 17;
    }else if(IS_IPHONE_6P){
        iconX = 20;
    }else{
        iconX = 16;
    }
    CGFloat iconH = 26;
    CGFloat iconW = 26;
    CGFloat iconY = (self.height - iconH)/2;
    self.icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    //1、设置label的frame
    CGFloat labelX = CGRectGetMaxX(self.icon.frame) + QKMargin+QKUImargin;
    CGSize labelSize = [self.showBalanceLabel.text sizeWithAttributes:@{NSFontAttributeName:self.showBalanceLabel.font}];
    CGFloat labelY = (self.height - labelSize.height)/2;
    self.showBalanceLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
   //2、开心豆数量label
    CGFloat peaX = CGRectGetMaxX(self.showBalanceLabel.frame)+2;
    CGFloat peaY = self.showBalanceLabel.y;
    CGSize peaSize = [self.peaCountLabel.text sizeWithAttributes:@{NSFontAttributeName:self.peaCountLabel.font}];
    self.peaCountLabel.frame = CGRectMake(peaX, peaY, peaSize.width, peaSize.height);
    //
    self.swLabel.x = CGRectGetMaxX(self.peaCountLabel.frame);
    self.swLabel.y = self.showBalanceLabel.y;
    self.swLabel.size = [self.swLabel.text sizeWithAttributes:@{NSFontAttributeName:self.swLabel.font}];
    
    self.rechargeBtn.width = (QKScreenWidth - CGRectGetMaxX(self.swLabel.frame)- 5 * QKCellMargin)/2;
    self.rechargeBtn.height = self.rechargeBtn.width/2.5;
    self.rechargeBtn.x = CGRectGetMaxX(self.swLabel.frame) + 3 * QKCellMargin;
    self.rechargeBtn.y = (self.height - self.rechargeBtn.height)/2;
    
    self.shoppingBtn.width = self.rechargeBtn.width;
    self.shoppingBtn.height = self.rechargeBtn.height;
    self.shoppingBtn.x = CGRectGetMaxX(self.rechargeBtn.frame) + QKCellMargin;
    self.shoppingBtn.y = self.rechargeBtn.y;
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
