//
//  QKHappyVideoController.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/1.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKHappyVideoController.h"
#import "QKLoginViewController.h"
@interface QKHappyVideoController ()

@end

@implementation QKHappyVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = request.URL.absoluteString;
    DCLog(@"%@",str);
    if ([str hasPrefix:@"ios://ios//"]) {
        NSArray * array= [str componentsSeparatedByString:@"//ios//"];
        NSString * ocMethod = array.lastObject;
        //        NSLog(@"%@",ocMethod);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(ocMethod)];
#pragma clang diagnostic pop
        return NO;
    }
    return YES;
    
}

-(void)removeAccount
{
    QKLoginViewController* loginVc = [[QKLoginViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
