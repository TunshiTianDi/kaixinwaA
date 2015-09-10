//
//  QKBackgroudTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/27.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKBackgroudTool.h"

@implementation QKBackgroudTool
+(UIImage *)gaussianBlur:(UIImage*)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(20),
                        nil];
    
    CIImage *outputImage = filter.outputImage;
//    CGRect extent = CGRectInset(filter.outputImage.extent, 1, 1);
    
    CGImageRef outImage = [context createCGImage:outputImage
                                             fromRect:inputImage.extent];
    return [UIImage imageWithCGImage:outImage];
    
}

@end
