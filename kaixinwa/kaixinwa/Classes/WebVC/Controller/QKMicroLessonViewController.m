//
//  QKMicroLessonViewController.m
//  kaixinwa
//
//  Created by qkhlios on 15/8/17.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKMicroLessonViewController.h"
#import "QKShareTool.h"
#import "WXApi.h"

@interface QKMicroLessonViewController ()
@property(nonatomic,assign) BOOL touched;
@property(nonatomic,copy)NSString * shareContent;
@end
static NSString * imageUrl = @"http://182.92.244.120/micro/images/start.png";
@implementation QKMicroLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WXApi isWXAppInstalled]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(toShare)];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:187/255.0 green:188/255.0 blue:189/255.0 alpha:1.0];
    }
    
}

- (void)toShare
{
    
    NSMutableArray *menuItems = [NSMutableArray array];
    
    menuItems = (NSMutableArray *) @[[KxMenuItem menuItem:@"分享到微信"
                                                    image:[UIImage imageNamed:@"wechat"] target:self action:@selector(ShareToWechat)],
                                     [KxMenuItem menuItem:@"分享到朋友圈"
                                                    image:[UIImage imageNamed:@"moments"] target:self action:@selector(ShareToTimeLine)],
                                     [KxMenuItem menuItem:@"分享到QQ"
                                                    image:[UIImage imageNamed:@"qq"] target:self action:@selector(ShareToQQ)],
                                     //                                          [KxMenuItem menuItem:@"调整字体大小"
                                     //                                                         image:[UIImage imageNamed:@"adjust"] target:self action:@selector(change)],
                                     
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.touched=NO;
    
}
-(void)change
{
    DCLog(@"调整字体");
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName_r('body')[0].style.webkitTextSizeAdjust= '150%'"];
}



- (void)ShareToWechat
{
    NSString * title = [NSString stringWithFormat:@"第%@集",self.number];
    [QKShareTool shareContentToType:UMShareToWechatSession andImageUrl:imageUrl andTitle:title andShareUrl:self.urlForShare andPresentVc:self andContent:self.shareContent];
}


    

- (void)ShareToTimeLine
{
    NSString * title = [NSString stringWithFormat:@"第%@集",self.number];
    [QKShareTool shareContentToType:UMShareToWechatTimeline andImageUrl:imageUrl andTitle:title andShareUrl:self.urlForShare andPresentVc:self andContent:self.shareContent];
    
}
- (void)ShareToQQ
{
    NSString * title = [NSString stringWithFormat:@"第%@集",self.number];
    [QKShareTool shareContentToType:UMShareToQQ andImageUrl:imageUrl andTitle:title andShareUrl:self.urlForShare andPresentVc:self andContent:self.shareContent];
    
}
//- (void)ShareToQZone
//{
//    NSString * title = [NSString stringWithFormat:@"第%@集",self.number];
//    [QKShareTool shareContentToType:UMShareToQzone andImageUrl:imageUrl andTitle:title andShareUrl:self.urlForShare andPresentVc:self andContent:nil];
//}




- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString * str = request.URL.absoluteString;
    NSLog(@"%@",str);
    self.urlForShare = request.URL.absoluteString;
    if ([str hasPrefix:@"http://182.92.244.120/micro/"]){
        self.number = [self cutString:str withName:@"mengtaiqi"];
        self.shareContent = @"《萌太奇》是乾坤翰林动画创意研发团队精心打造的Flash创意动画短片，该片用巧妙的卡通手法演绎了主人公萌太奇幻想奇妙的旅程故事。刻画了一个喜欢幻想的小女孩形象，彰显让孩子发散思维、快乐成长的主题。整部动画片从头至尾美妙奇幻、轻松愉快。";
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
