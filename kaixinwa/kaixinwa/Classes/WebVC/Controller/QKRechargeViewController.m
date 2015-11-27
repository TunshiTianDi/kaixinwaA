//
//  QKRechargeViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/26.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKRechargeViewController.h"
#import <StoreKit/StoreKit.h>
#import "QKLoadingView.h"

@interface QKRechargeViewController ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property(nonatomic,copy)NSString * price;

@property(nonatomic,strong)NSArray *products;
//等待视图
@property(nonatomic,weak)QKLoadingView * loadingView;
@end

@implementation QKRechargeViewController
-(NSArray *)products
{
    if (!_products) {
        _products = [NSArray array];
    }
    return _products;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加等待视图
    QKLoadingView * loadingView = [[QKLoadingView alloc]initWithFrame:self.view.bounds];
    self.loadingView = loadingView;
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    // 1.加载想要销售的商品(NSArray)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"products.plist" ofType:nil];
    NSArray *productsArray = [NSArray arrayWithContentsOfFile:path];
    
    // 2.取出所有想要销售商品的productId(NSArray)
    NSArray *productIdsArray = [productsArray valueForKeyPath:@"productId"];
    
    // 3.将所有的productId放入NSSet当中
    NSSet *productIdsSet = [NSSet setWithArray:productIdsArray];
    
    // 4.创建一个请求对象
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdsSet];
    
    // 4.1.设置代理
    request.delegate = self;
    
    // 5.开始请求可销售的商品
    [request start];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
/**
 *  当请求到可销售的商品的时候,会调用该方法
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [self.loadingView hideView];
    self.loadingView = nil;
    for (SKProduct *product in response.products) {
        NSLog(@"%@", product.localizedTitle);
        NSLog(@"%@", product.localizedDescription);
        NSLog(@"%@", product.price);
        NSLog(@"%@", product.productIdentifier);
    }
    
    // 1.保留所有的可销售商品
    self.products = response.products;
    [self loadUrlWithString:self.urlStr];
}

-(void)recharge
{
    NSLog(@"recharge js--%@",self.price);
    QKLoadingView * loading = [[QKLoadingView alloc]init];
    loading.backgroundColor = [UIColor blackColor];
    loading.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        loading.alpha = 0.3;
    }];
    [loading showInView:self.navigationController.view];
    self.loadingView = loading;
    
    for (SKProduct * product in self.products) {
        if ([[product.price stringValue] isEqualToString:self.price]) {
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}
/**
 当交易队列当中,有交易状态发生改变的时候会执行该方法
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 已经购买(向服务器发送请求,给用户东西,停止该交易)
     SKPaymentTransactionStateFailed, 购买失败
     SKPaymentTransactionStateRestored 恢复购买成功(向服务器发送请求,给用户东西,停止该交易)
     SKPaymentTransactionStateDeferred (iOS8-->用户还未决定最终状态)
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                
                break;
            case SKPaymentTransactionStatePurchased:
                // 请求给用户物品
                NSLog(@"用户购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self.loadingView hideView];
                self.loadingView = nil;
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"用户购买失败");
                [self.loadingView hideView];
                self.loadingView = nil;
                break;
            case SKPaymentTransactionStateRestored:
                // 请求给用户物品
                NSLog(@"用户恢复购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self.loadingView hideView];
                self.loadingView = nil;
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"用户还未决定");
                break;
            default:
                break;
        }
        
    }
}


#pragma mark - webviewDelegate 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = request.URL.absoluteString;
    
    if ([str hasPrefix:@"ios://recharge"]) {
        NSArray * array= [str componentsSeparatedByString:@"://"];
        NSString * str1 = array.lastObject;
        NSArray * str1Array = [str1 componentsSeparatedByString:@"/price/"];
        DCLog(@"1-%@-2-%@",str1Array.firstObject,str1Array.lastObject);
        NSString * ocMethod = str1Array.firstObject;
        self.price = str1Array.lastObject;
        //js通过方法名调用oc方法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(ocMethod)];
#pragma clang diagnostic pop
        return NO;
    }
    return YES;
    
}



@end
