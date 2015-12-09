//
//  QKShareTool.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/24.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKShareTool.h"
#import "UMSocial.h"
#import "QKDataBaseTool.h"

@implementation QKShareTool
+(void)shareContentToType:(NSString *const)shareTo
              andImageUrl:(NSString *)imageUrl
                 andTitle:(NSString *)title
              andShareUrl:(NSString*)urlForShare
             andPresentVc:(UIViewController *)presentedController
               andContent:(NSString *)content
{
    DCLog(@"分享到%@",shareTo);
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        imageUrl];
    if ([shareTo isEqualToString:UMShareToQQ]) {
        [UMSocialData defaultData].extConfig.qqData.url = urlForShare;
        
        [UMSocialData defaultData].extConfig.qqData.title = title;
    }else if([shareTo isEqualToString:UMShareToWechatSession]){
        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlForShare;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    }else if([shareTo isEqualToString:UMShareToWechatTimeline]){
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlForShare;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    }else{
        [UMSocialData defaultData].extConfig.qzoneData.url = urlForShare;
        
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
    }
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareTo] content:content image:nil location:nil urlResource:urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            //将分享内容插入数据库中
//            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
//            NSString * creattime = [NSString stringWithFormat:@"%lf",nowtime];
            
            
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }];
}

@end
