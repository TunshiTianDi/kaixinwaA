//
//  QKQRScanView.m
//  kaixinwa
//
//  Created by 张思源 on 15/9/7.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//
#define ScanViewWidthAndHeight QKScreenWidth * 0.6
#define QKScreenHeight [UIScreen mainScreen].bounds.size.height

#import "QKQRScanView.h"



@interface QKQRScanView()

@end

@implementation QKQRScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMaskView];
        [self setupScanWindowView];
        
    }
    return self;
}

-(void)setupMaskView
{
    UIView * mask = [[UIView alloc]init];
    self.maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    mask.layer.borderWidth = (self.height - ScanViewWidthAndHeight)/2;
    
    mask.bounds = CGRectMake(0, 0, self.width *(self.height/self.width) , self.height);
    mask.centerX = self.centerX;
    mask.y = 0;
    UIImageView * imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"scan_icon"]];
    imageView.size = CGSizeMake(40, 40);
    imageView.x = 0;
    imageView.y = 0;
    UILabel * label = [[UILabel alloc]init];
    label.text = @"把二维码放到框框里就可以扫描了";
    //    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    label.numberOfLines= 2;
    label.font = [UIFont systemFontOfSize:14];
    label.size = CGSizeMake(120, 40);
    label.x = CGRectGetMaxX(imageView.frame)+5;
    label.y = 0;
    UIView * iconAndLabelView = [[UIView alloc]init];
    iconAndLabelView.backgroundColor = [UIColor clearColor];
    iconAndLabelView.size = CGSizeMake(165, 40);
    iconAndLabelView.x = (self.width - iconAndLabelView.width)/2;
    iconAndLabelView.y = self.height * 0.2;
    [iconAndLabelView addSubview:imageView];
    [iconAndLabelView addSubview:label];
    [self addSubview:iconAndLabelView];
    [self addSubview:mask];
    
}
- (void)setupScanWindowView
{
    
    UIView *scanWindow = [[UIView alloc] init];
    scanWindow.width = ScanViewWidthAndHeight;
    scanWindow.height = ScanViewWidthAndHeight;
    scanWindow.y = (self.height - scanWindow.height) / 2;
    scanWindow.x =(self.width - scanWindow.width)/2;
    scanWindow.clipsToBounds = YES;
    [self addSubview:scanWindow];
    
    CGFloat scanNetImageViewH = ScanViewWidthAndHeight;
    CGFloat scanNetImageViewW = scanWindow.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindow.height);
    scanNetAnimation.duration = 1.5;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    //  设置4个边框
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindow.width - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindow.height - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
}


@end
