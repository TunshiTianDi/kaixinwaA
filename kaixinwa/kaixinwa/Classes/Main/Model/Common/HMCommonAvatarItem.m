//
//  HMCommonAvatarItem.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/24.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "HMCommonAvatarItem.h"

@implementation HMCommonAvatarItem
-(UIImage *)addImage:(UIImage *)image
{
    CGSize newSize = CGSizeMake(320, 320);
    UIImage * newImage = [self OriginImage:image scaleToSize:newSize];
//    UIImage * cirleImage = [self circleImage:newImage withParam:0];
//    [self.iconView setImage:cirleImage];
//    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
//    self.iconView.clipsToBounds = YES;
    return newImage;
}

//图片处理
#pragma mark 图片处理
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
