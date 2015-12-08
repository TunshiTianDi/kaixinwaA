//
//  QKTimeLimitDetailViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/30.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKTimeLimitDetailViewController.h"
#import "QKLoginViewController.h"
#import "QKRechargeViewController.h"
#import "QKAccount.h"
#import "QKAccountTool.h"

@interface QKTimeLimitDetailViewController ()

@end

@implementation QKTimeLimitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = request.URL.absoluteString;
//    DCLog(@"----%@",str);
    if ([str hasPrefix:@"ios://ios//"]) {
        NSArray * array= [str componentsSeparatedByString:@"//ios//"];
        NSString * ocMethod = array.lastObject;
//        NSLog(@"%@",ocMethod);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(ocMethod)];
#pragma clang diagnostic pop
        return NO;
    }else if([str hasPrefix:@"ios://push"]){
        NSArray * array = [str componentsSeparatedByString:@"://"];
        NSString * ocMethod = array.lastObject;
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

-(void)pushRechargeViewController
{
    NSString * str = [NSString stringWithFormat:@"http://101.200.173.111/kaixinwa2.0/mall.php/Index/recharge?uid=%@",[QKAccountTool readAccount].uid];
    QKRechargeViewController * recharge = [[QKRechargeViewController alloc]init];
    recharge.urlStr = str;
    [self.navigationController pushViewController:recharge animated:YES];
}

@end
