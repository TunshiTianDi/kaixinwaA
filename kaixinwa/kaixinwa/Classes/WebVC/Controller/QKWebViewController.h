//
//  QKWebViewController.h
//  HappyFrogAnswer
//
//  Created by 张思源 on 15/8/4.
//  Copyright (c) 2015年 张思源. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "KxMenu.h"
#import "UMSocial.h"
@interface QKWebViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property(nonatomic,weak)UIWebView * myWebView;
@property(nonatomic,copy)NSString * webName;
@property(nonatomic,copy)NSString * urlStr;
/** 分享的url*/
@property(nonatomic,copy)NSString * urlForShare;
/** 分享的集数*/
@property(nonatomic,copy)NSString * number;

@property(nonatomic,strong)NSURLRequest * currentRequest;

-(NSString *)cutString:(NSString *)str withName:(NSString*)name;
-(void)loadUrlWithString:(NSString *)urlStr;

@end
