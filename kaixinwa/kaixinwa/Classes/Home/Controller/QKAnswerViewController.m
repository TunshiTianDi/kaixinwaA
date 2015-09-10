//
//  QKAnswerViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/17.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKAnswerViewController.h"
//#import "QKQRCodeViewController.h"
@interface QKAnswerViewController ()
@property(nonatomic,weak)UIButton * zsBtn;
@property(nonatomic,weak)UIButton * xlBtn;
@property(nonatomic,weak)UIButton * ygBtn;
@property(nonatomic,weak)UIWebView * webView;
@end

@implementation QKAnswerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"开心蛙答案";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fanhui" highImageName:@"jiantousel" target:self action:@selector(toBack)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"scan" highImageName:@"scan" target:self action:@selector(toScan)];
    [self creatUI];
    
}
-(void)toBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//-(void)toScan
//{
//    QKQRCodeViewController * qrVc = [[QKQRCodeViewController alloc]init];
//    
//    [self.navigationController pushViewController:qrVc animated:YES];
//}

-(void)creatUI
{
    UIView * segView = [[UIView alloc]init];
    segView.x = 0;
    segView.y = 64;
    segView.height = 50;
    segView.width = QKScreenWidth;
    [self.view addSubview:segView];
    self.zsBtn = [self creatButtonTitle:@"知识月亮泉" andView:segView andTag:1];
    self.zsBtn.selected = YES;
    self.xlBtn =[self creatButtonTitle:@"心路浪花滩" andView:segView andTag:2];
    self.ygBtn =[self creatButtonTitle:@"阳光绿野洲" andView:segView andTag:3];
    
    UIWebView * webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.y = 64 + segView.height;
    webView.height = self.view.height - webView.y;
    self.webView = webView;
    NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.163/qkhl_api/index.php/Phone/Answer/getanswer?unique_code=%@&tab=1",self.unique_code];
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
-(UIButton*)creatButtonTitle:(NSString *)title andView:(UIView *)view andTag:(NSInteger)tag;
{
    UIButton * button = [[UIButton alloc]init];
    button.width = QKScreenWidth/3;
    button.height = view.height;
    button.x = (tag-1) * button.width;
    button.y = 0;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:QKColor(109, 109, 109) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage resizedImage:@"underline"] forState:UIControlStateSelected];
    button.tag = tag;
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return button;
}


-(void)onClick:(UIButton *)sender{
    
    switch (sender.tag) {
            
        case 1:{
//            DCLog(@"知识");
            self.zsBtn.selected = YES;
            self.xlBtn.selected = NO;
            self.ygBtn.selected = NO;
            NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.163/qkhl_api/index.php/Phone/Answer/getanswer?unique_code=%@&tab=%li",self.unique_code,(long)sender.tag];
            NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            [self.webView loadRequest:request];
            
            break;
        }
        case 2:{
//            DCLog(@"心路");
            self.zsBtn.selected = NO;
            self.xlBtn.selected = YES;
            self.ygBtn.selected = NO;
            NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.163/qkhl_api/index.php/Phone/Answer/getanswer?unique_code=%@&tab=%li",self.unique_code,(long)sender.tag];
            NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            [self.webView loadRequest:request];
            
            break;
        }
        case 3:{
//            DCLog(@"阳光");
            self.zsBtn.selected = NO;
            self.xlBtn.selected = NO;
            self.ygBtn.selected = YES;
            NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.163/qkhl_api/index.php/Phone/Answer/getanswer?unique_code=%@&tab=%li",self.unique_code,(long)sender.tag];
            NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
            [self.webView loadRequest:request];
            
            break;
        }
        default:
            break;
            
    }
    
}


@end
