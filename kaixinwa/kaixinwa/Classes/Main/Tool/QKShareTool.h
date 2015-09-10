//
//  QKShareTool.h
//  kaixinwa
//
//  Created by 张思源 on 15/8/24.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKShareTool : NSObject

+(void)shareContentToType:(NSString *const)shareTo
              andImageUrl:(NSString *)imageUrl
                 andTitle:(NSString *)title
              andShareUrl:(NSString*)urlForShare
             andPresentVc:(UIViewController *)presentedController
               andContent:(NSString *)content;
@end
