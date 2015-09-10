//
//  QKRadioViewController.m
//  kaixinwa
//
//  Created by qkhlios on 15/8/18.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKRadioViewController.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "QKShareTool.h"

@interface QKRadioViewController ()
@property(nonatomic,assign) BOOL touched;
@end

@implementation QKRadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem =  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
//    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:187/255.0 green:188/255.0 blue:189/255.0 alpha:1.0];
}

- (void)share
{
    NSMutableArray * menuItems = [NSMutableArray array];
    if (![WXApi isWXAppInstalled]) {
        menuItems = (NSMutableArray * )@[[KxMenuItem menuItem:@"调整字体大小" image:[UIImage imageNamed:@"adjust"] target:self action:@selector(adjustFont)]];
    }else{
        menuItems = (NSMutableArray *)@[[KxMenuItem menuItem:@"分享到微信" image:[UIImage imageNamed:@"wechat"] target:self action:@selector(ShareToWechat)],
        [KxMenuItem menuItem:@"分享到朋友圈" image:[UIImage imageNamed:@"moments"] target:self action:@selector(ShareToTimeLine)],
        [KxMenuItem menuItem:@"分享到QQ" image:[UIImage imageNamed:@"qq"] target:self action:@selector(ShareToQQ)],
        
//                                        [KxMenuItem menuItem:@"分享到QQ空间" image:[UIImage imageNamed:@"search_icon"] target:self action:@selector(ShareToQzone)]
                                        ];
        
         
         };
    if (self.touched==NO) {
        [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.width-40, 34, 30, 30) menuItems:menuItems];
        self.touched=YES;
    }
    else if (self.touched==YES) {
        [KxMenu dismissMenu];
        self.touched=NO;
    }
    

}
- (void)adjustFont
{
    NSLog(@"adjustFont");
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.touched=NO;
    
}


-(void)ShareToWechat
{
    NSLog(@"分享到微信");
    UMSocialUrlResource  * urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://182.92.244.120/micro/images/start.png"];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url= self.urlForShare;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"开心蛙";
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:@"hhaha" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode==UMSResponseCodeSuccess) {
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }];
    
}
-(void)ShareToTimeLine
{
    NSLog(@"分享到朋友圈");
    
    UMSocialUrlResource * urlResource= [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://182.92.244.120/micro/images/start.png"];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlForShare;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"开心蛙";
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:@"待定" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode==UMSResponseCodeSuccess) {
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }];
    
}
-(void)ShareToQQ
{
    NSLog(@"分享到QQ");
    UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://182.92.244.120/micro/images/start.png"];
    [UMSocialData defaultData].extConfig.qqData.url = self.urlForShare;
    [UMSocialData defaultData].extConfig.qzoneData.title = @"开心大蛤蟆";
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:@"开心蛙" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode==UMSResponseCodeSuccess) {
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }];
}
//- (void)ShareToQzone
//{
//    NSLog(@"分享到QQ空间");
//    UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:@"http://182.92.244.120/micro/images/start.png"];
//    [UMSocialData defaultData].extConfig.qzoneData.url = self.urlForShare;
//    [UMSocialData defaultData].extConfig.qzoneData.title = @"开心蛙";
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:@"开心蛙" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//        if (response.responseCode==UMSResponseCodeSuccess) {
//            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [av show];
//        }
//    }];

//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * str = request.URL.absoluteString;
    NSLog(@"%@",str);
    self.urlForShare = request.URL.absoluteString;
    if ([str hasPrefix:@"http://101.200.173.163/qkhl_api/index.php/Phone/Radio/detail"]) {
        self.number = [str componentsSeparatedByString:@"detail/id/"].lastObject;
        return YES;
    }
    return YES;
}

@end
