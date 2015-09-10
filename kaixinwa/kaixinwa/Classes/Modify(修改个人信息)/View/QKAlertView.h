//
//  QKAlertView.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/18.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCommonLabelItem.h"
@class QKAlertView;

@protocol QKAlertViewDelegate <NSObject>

@optional
- (void)alertViewClickSubmitButton:(QKAlertView*)alertView;
@end

@interface QKAlertView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property(weak,nonatomic)id<QKAlertViewDelegate>delegate;
@property(copy,nonatomic)NSString * updateType;
@property(strong,nonatomic)HMCommonLabelItem * item;
-(void)hide;
-(void)showInView:(UIView *)view;

@end
