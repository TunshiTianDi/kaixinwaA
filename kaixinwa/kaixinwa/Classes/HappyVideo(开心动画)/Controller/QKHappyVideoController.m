//
//  QKHappyVideoController.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/1.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKHappyVideoController.h"

@interface QKHappyVideoController ()

@end

@implementation QKHappyVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DCLog(@"%@",request.URL.absoluteString);
    return YES;
    
}
@end
