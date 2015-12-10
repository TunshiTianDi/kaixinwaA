//
//  QKWebViewController.m
//  HappyFrogAnswer
//
//  Created by 张思源 on 15/8/4.
//  Copyright (c) 2015年 张思源. All rights reserved.
//

#import "QKWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "AppDelegate.h"
#import "QKNotFoundNetView.h"
#import "MBProgressHUD+MJ.h"
#import "QKRechargeViewController.h"

@interface QKWebViewController ()<QKNotFoundNetViewDelegate>

@property(nonatomic,strong)NJKWebViewProgressView * progressView;
@property(nonatomic,strong)NJKWebViewProgress * webProgress;
@property(nonatomic,strong)NSString * shareContent;
//是否连接失败
@property(nonatomic,assign)BOOL isFail;


@end

@implementation QKWebViewController
-(NJKWebViewProgress *)webProgress
{
    if (!_webProgress) {
        _webProgress = [[NJKWebViewProgress alloc]init];
        _webProgress.webViewProxyDelegate = self;
        _webProgress.progressDelegate = self;
    }
    return _webProgress;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImageName:@"fanhui" highImageName:@"jiantousel" target:self action:@selector(back)];
    
    
    //创建webView
    UIWebView * myWebView = [[UIWebView alloc]init];
    myWebView.frame = self.view.bounds;
    [self.view addSubview:myWebView];
    myWebView.delegate = self.webProgress;
//    myWebView.scalesPageToFit = YES;
    self.myWebView = myWebView;
    
    self.currentRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    //创建加载进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    if (![self isKindOfClass:[QKRechargeViewController class]]) {
        [self loadUrlWithString:self.urlStr];
    }else{
        self.progressView.hidden = YES;
    }
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
}

-(void)back
{
    if (self.myWebView.canGoBack) {
        [self.myWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar addSubview:self.progressView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.progressView removeFromSuperview];
}

-(void)loadUrlWithString:(NSString *)urlStr
{
    self.progressView.hidden = NO;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [self.myWebView loadRequest:req];
}

-(NSString *)cutString:(NSString *)str withName:(NSString*)name
{
    NSArray * shareArr = [str componentsSeparatedByString:name];
    NSString * numNature = shareArr.lastObject;
    NSString * num = [numNature componentsSeparatedByString:@"."].firstObject;
    return num;
}
#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.isFail = NO;
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isFail = NO;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    self.isFail = YES;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (self.isFail && !appDelegate.isExistenceNetwork) {
        //创建连接失败视图
        QKNotFoundNetView * notFoundView = [[QKNotFoundNetView alloc]init];
        notFoundView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        notFoundView.delegate = self;
        [self.view addSubview:notFoundView];
        
    }
    
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
    [self.progressView setProgress:progress animated:YES];
    
    
    self.title = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.title isEqualToString:@""]||self.title == nil) {
        self.title = self.webName;
    }
}

#pragma mark - 通知方法实现
#pragma mark  startFullScreen
-(void)begainFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isFull = YES;
}
#pragma mark endFullScreen
-(void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isFull = NO;
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark - notfoundDelegate
- (void)clickReloadButton:(QKNotFoundNetView *)notFoundNetView
{
    [self.myWebView loadRequest:self.currentRequest];
    
        
    [notFoundNetView hideInOtherView:self.myWebView];

}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [KxMenu dismissMenu];
}


@end
