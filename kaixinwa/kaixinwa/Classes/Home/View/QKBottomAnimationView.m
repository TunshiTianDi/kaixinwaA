//
//  QKBottomAnimationView.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/4.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKBottomAnimationView.h"
#import "QKImageTextView.h"
#import "QKVideo.h"
#import "UIImageView+WebCache.h"

@implementation QKBottomAnimationView

-(void)setItems:(NSArray *)items
{
    _items = items;
    for (int i = 0; i < items.count; i++) {
        QKImageTextView * itView = [[QKImageTextView alloc]init];
        QKVideo * video = items[i];
        [itView.imageView sd_setImageWithURL:[NSURL URLWithString:video.type_face_url] placeholderImage:nil];
        itView.nameLabel.text = video.type_name;
        itView.tag = i + 8;
        [self addSubview:itView];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i<self.subviews.count; i++) {
        QKImageTextView * itView = self.subviews[i];
        itView.width = (self.width - 6 * QKCellMargin)/3;
        itView.x = QKCellMargin + i * (itView.width + 2 * QKCellMargin);
        itView.height = self.height;
        itView.y = 0;
    }
    
}

@end
