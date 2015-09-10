//
//  QKAlertView.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/18.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKAlertView.h"

@implementation QKAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"QKAlertView" owner:self options:nil] objectAtIndex:0];
        [self.submitButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)hide
{
    [self removeFromSuperview];
}
-(void)onClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(alertViewClickSubmitButton:)]) {
        [self.delegate alertViewClickSubmitButton:self];
    }
}
-(void)showInView:(UIView *)view
{
    self.centerY = view.centerY;
    self.centerX = view.centerX;
    self.size = CGSizeZero;
    [self.textField becomeFirstResponder];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.size = CGSizeMake(260, 140);
        self.x = (view.width - self.width)/2;
        self.centerY = view.centerY - 100;
    }];
}
@end
