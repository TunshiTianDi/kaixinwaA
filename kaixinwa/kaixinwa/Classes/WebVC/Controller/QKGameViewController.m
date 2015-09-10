//
//  QKGameViewController.m
//  kaixinwa
//
//  Created by qkhlios on 15/8/18.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKGameViewController.h"
#import "WXApi.h"
#import "QKShareTool.h"

@interface QKGameViewController ()
@property(nonatomic,assign) BOOL touched;
@end

@implementation QKGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WXApi isWXAppInstalled]) {
        self.navigationItem.rightBarButtonItem =  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(ToShare)];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:187/255.0 green:188/255.0 blue:189/255.0 alpha:1.0];
    }
    
    self.touched = NO;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor colorWithRed:187/255.0 green:188/255.0 blue:189/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
}




- (void)goBack
{
    
    
    if ([self.urlForShare isEqual:@"http://101.201.176.9/kxw_game/index.html"]==YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
//        [self loadUrlWithString:@"http://101.201.176.9/kxw_game/index.html"];
        [self.myWebView goBack];
    }
    
    
}




- (void)ToShare
{
    
    NSMutableArray * menuItems = [NSMutableArray array];
        menuItems = (NSMutableArray *)@[[KxMenuItem menuItem:@"分享到微信" image:[UIImage imageNamed:@"wechat"] target:self action:@selector(ShareToWechat)],
                                        [KxMenuItem menuItem:@"分享到朋友圈" image:[UIImage imageNamed:@"moments"] target:self action:@selector(ShareToTimeLine)],
                                        [KxMenuItem menuItem:@"分享到QQ" image:[UIImage imageNamed:@"qq"] target:self action:@selector(ShareToQQ)],
//                                        [KxMenuItem menuItem:@"调整字体大小" image:[UIImage imageNamed:@"adjust"] target:self action:@selector(adjustFont)]
//                                        [KxMenuItem menuItem:@"分享到QQ空间" image:[UIImage imageNamed:@"search_icon"] target:self action:@selector(ShareToQzone)]
                                        ];
        
        

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
    DCLog(@"adjustFont");
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.touched=NO;
}



-(void)ShareToWechat
{
    [QKShareTool shareContentToType:UMShareToWechatSession andImageUrl:self.gameImageUrl andTitle:self.gameTitle andShareUrl:self.urlForShare andPresentVc:self andContent:self.gameContent];
}
-(void)ShareToTimeLine
{
    [QKShareTool shareContentToType:UMShareToWechatTimeline andImageUrl:self.gameImageUrl andTitle:self.gameTitle andShareUrl:self.urlForShare andPresentVc:self andContent:self.gameContent];
    
}
-(void)ShareToQQ
{
    [QKShareTool shareContentToType:UMShareToQQ andImageUrl:self.gameImageUrl andTitle:self.gameTitle andShareUrl:self.urlForShare andPresentVc:self andContent:self.gameContent];
    
}

//- (void)ShareToQzone
//{
//    NSLog(@"分享到QQ空间");
//    UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.number];
//    
//    [UMSocialData defaultData].extConfig.qzoneData.url = self.urlForShare;
//    [UMSocialData defaultData].extConfig.qzoneData.title = self.gameTitle;
//    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.gameContent image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response) {
//        if (response.responseCode==UMSResponseCodeSuccess) {
//            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"消息" message:@"分享成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [av show];
//        }
//    }];
//    
//    
//}
//


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString * str = request.URL.absoluteString;
    NSLog(@"%@",str);
    self.urlForShare = request.URL.absoluteString;
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/coreball/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/games/coreball/icon.png";
        self.gameContent =@"据说能玩过30关的人，全世界不超过15个??????";
        self.gameTitle = @"开心游戏－动手动脑";
        return YES;
    }
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/zpfff/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/games/zpfff/icon.png";
        self.gameContent= @"想要学好三字经么，点我就可以了";
        self.gameTitle = @"开心游戏－字牌翻翻翻";
        return YES;
    }
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/get36/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/games/get36/icon.png";
        self.gameContent=@"我想你一定知道几加几等于36，但是你一定没这么玩过。";
        self.gameTitle = @"开心游戏-get36";
        return YES;
    }
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/freekick/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/games/freekick/icon.png";
        self.gameContent = @"用手踢点球，你试过吗？";
        self.gameTitle =@"开心游戏－任意球大师";
        return YES;
    }
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/zuiqiangyanli/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/icon/zqyl.png";
        self.gameContent =@"这是眼力和脑力的终极挑战，敢来么？";
        self.gameTitle = @"开心游戏－最强眼力";
        return YES;
    }
    if ([str hasPrefix:@"http://qkhl-api.com/kxw_game/games/duimutou/"]) {
        self.gameImageUrl = @"http://101.201.176.9/kxw_game/icon/duimutou.png";
        self.gameContent = @"各个方面都应该高标准的要求自己，所以木头一定要堆的高高的。";
        self.gameTitle = @"开心游戏－堆木头";
        return YES;
    }
    if ([str hasPrefix:@"http://101.201.176.9/kxw_game/index.html"]) {
        self.gameImageUrl = @"http://a3.qpic.cn/psb?/V11orvgk41lQCt/FCOEXpmc4x8TUm9e7nEcDf4tTjYPzTpYVwhOEFjMGJY!/b/dGEBAAAAAAAA&bo=.QD5APkA.QADACU!&rf=viewer_4";
        self.gameContent = @"开心蛙，益智小游戏，边游戏边学习，快速开动你的小脑筋";
        self.gameTitle =@"开心游戏";
        return YES;
    }
    
    
  
   
    return YES;
}



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

@end
