//
//  QKGridView.h
//  kaixinwa
//
//  Created by 张思源 on 15/11/3.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKGridView : UIView

@property(nonatomic,strong)NSArray * items;
@property(nonatomic,assign)NSUInteger moreBtnTag;
@property(nonatomic,copy)NSString * title;


@end
