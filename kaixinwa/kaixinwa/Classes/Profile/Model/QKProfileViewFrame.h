//
//  QKProfileViewFrame.h
//  kaixinwa
//
//  Created by 张思源 on 15/11/24.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QKAccount;
@interface QKProfileViewFrame : NSObject

@property(nonatomic,strong)QKAccount * account;

@property(nonatomic,assign)CGRect iconFrame;

@property(nonatomic,assign)CGRect iconBGFrame;

@property(nonatomic,assign)CGRect iconCameraFrame;

@property(nonatomic,assign)CGRect nameLabelFrame;

@property(nonatomic,assign)CGRect schoolLabelFrame;

@property(nonatomic,assign)CGRect signatureLabelFrame;

@property(nonatomic,assign)CGRect templeLabelFrame;

@property(nonatomic,assign)CGRect frame;

@end

