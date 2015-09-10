//
//  QKNotFoundNetView.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/20.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QKNotFoundNetView;

@protocol QKNotFoundNetViewDelegate <NSObject>

@optional
- (void)clickReloadButton:(QKNotFoundNetView *)notFoundNetView;
@end

@interface QKNotFoundNetView : UIView

@property(weak,nonatomic)id<QKNotFoundNetViewDelegate>delegate;

-(void)showInView:(UIView *)view;
-(void)hideInOtherView:(UIView *)view;
@end
