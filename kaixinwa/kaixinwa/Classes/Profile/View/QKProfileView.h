//
//  QKProfileView.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QKProfileView;

@protocol QKProfileDelegate <NSObject>

@optional
- (void)tapProfileImage:(QKProfileView *)profileView;
@end

@interface QKProfileView : UIImageView
@property(nonatomic,weak)id<QKProfileDelegate>delegate;
@property (nonatomic , weak)UIImageView * icon;

@end
