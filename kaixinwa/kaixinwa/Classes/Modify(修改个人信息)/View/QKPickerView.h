//
//  QKPickerView.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/22.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKLocation.h"

@class QKPickerView;

@protocol QKAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(QKPickerView *)picker;
- (void)clickSubmit;
- (void)clickCancle;
@end
@interface QKPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIPickerView *areaPickView;
@property (nonatomic,strong)QKLocation * locate;
@property (nonatomic, assign, getter = isDimBackground) BOOL dimBackground;

@property(nonatomic,weak)id<QKAreaPickerDelegate>delegate;

- (id)initWithDelegate:(id <QKAreaPickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
@end
