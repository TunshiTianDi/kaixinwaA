//
//  QKShareTravelViewController.m
//  kaixinwa
//
//  Created by dc－mac on 15/8/16.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKShareTravelViewController.h"
#import "WXApi.h"
#import "QKDataBaseTool.h"


@interface QKShareTravelViewController ()

@end

@implementation QKShareTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webName = @"开心游学记";
    if ([WXApi isWXAppInstalled]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenxiang" highImageName:@"fenxiangsel" target:self action:@selector(toShare)];
    }
    
}

-(void)toShare
{
    
    NSMutableArray *menuItems = [NSMutableArray array];
    menuItems =
    (NSMutableArray *)@[
                        [KxMenuItem menuItem:@"分享到微信"
                                       image:[UIImage imageNamed:@"wechat"]
                                      target:self
                                      action:@selector(shareToWeixin)],
                        [KxMenuItem menuItem:@"分享到朋友圈"
                                       image:[UIImage imageNamed:@"moments"]
                                      target:self
                                      action:@selector(shareToTimeline)],
                        [KxMenuItem menuItem:@"分享到qq"
                                       image:[UIImage imageNamed:@"qq"]
                                      target:self
                                      action:@selector(shareToQQ)],
                        //                            [KxMenuItem menuItem:@"分享到qq空间"
                        //                                           image:[UIImage imageNamed:@"search_icon"]
                        //                                          target:self
                        //                                          action:@selector(shareToQzone)],
                        //                            [KxMenuItem menuItem:@"调整字体大小"
                        //                                           image:[UIImage imageNamed:@"adjust"]
                        //                                          target:self
                        //                                          action:@selector(changeFont)],
                        
                        ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.width - 40, 34, 30, 30)
                 menuItems:menuItems];
}


//-(void)changeFont
//{
//    
//}

-(void)shareToWeixin
{
    [self shareContentToType:UMShareToWechatSession];
}
-(void)shareToTimeline
{
    [self shareContentToType:UMShareToWechatTimeline];
}

-(void)shareToQQ
{
    [self shareContentToType:UMShareToQQ];
}
-(void)shareToQzone
{
    [self shareContentToType:UMShareToQzone];
}


-(void)shareContentToType:(NSString *const)shareTo
{
    DCLog(@"分享到%@",shareTo);
    NSString * imageUrl =[NSString stringWithFormat:@"http://101.200.173.163/travel/images/%@.jpg",self.number];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        imageUrl];
    NSString * title = [NSString stringWithFormat:@"开心蛙游学记 第%@集",self.number];
    if ([shareTo isEqualToString:UMShareToQQ]) {
        [UMSocialData defaultData].extConfig.qqData.url = self.urlForShare;
        
        [UMSocialData defaultData].extConfig.qqData.title = title;
    }else if([shareTo isEqualToString:UMShareToWechatSession]){
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlForShare;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    }else if([shareTo isEqualToString:UMShareToWechatTimeline]){
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlForShare;
       
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    }else{
        [UMSocialData defaultData].extConfig.qzoneData.url = self.urlForShare;
        
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
    }
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareTo] content:@"《开心蛙游学记》是一个365集童话故事片，导演为杨新红，由北京乾坤翰林文化传播有限公司出品。" image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            //将分享内容插入数据库中
            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
            NSString * creattime = [NSString stringWithFormat:@"%lf",nowtime];
            [QKDataBaseTool insertInShareTableWithTitle:title andShareUrl:self.urlForShare andImageUrl:imageUrl andCreatTime:creattime];
            
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
        }
    }];
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    NSString * str = request.URL.absoluteString;
    DCLog(@"%@",str);
    self.urlForShare = request.URL.absoluteString;
    if([str hasPrefix:@"http://101.200.173.163/travel/"]){
        self.number = [self cutString:str withName:@"youxueji"];
        return YES;
    }
    
    return YES;
}
@end
