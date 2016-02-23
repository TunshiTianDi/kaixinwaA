//
//  QKQRCodeViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#define ScanViewWidthAndHeight QKScreenWidth * 0.6
#define QKScreenHeight [UIScreen mainScreen].bounds.size.height
#import "QKQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QKWebViewController.h"
#import "QKAnswerViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"

@interface QKQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureSession * session;
@property(nonatomic,weak)UIView * maskView;
@end

@implementation QKQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.hidden = YES;
    self.view.clipsToBounds = YES;
    [self setupMaskView];
    [self setupBottomBar];
    [self setupScanWindowView];
    [self beginScanning];
    
}


-(void)setupMaskView
{
    UIView * mask = [[UIView alloc]init];
    self.maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    mask.layer.borderWidth = (self.view.height - ScanViewWidthAndHeight)/2;
    
    mask.bounds = CGRectMake(0, 0, self.view.width *(self.view.height/self.view.width) , self.view.height);
    mask.centerX = self.view.centerX;
    mask.y = 0;
    UIImageView * imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"scan_icon"]];
    imageView.size = CGSizeMake(40, 40);
    imageView.x = 0;
    imageView.y = 0;
    UILabel * label = [[UILabel alloc]init];
    label.text = @"把二维码放到框框里就可以扫描了";
//    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    label.numberOfLines= 2;
    label.font = [UIFont systemFontOfSize:14];
    label.size = CGSizeMake(120, 40);
    label.x = CGRectGetMaxX(imageView.frame)+5;
    label.y = 0;
    UIView * iconAndLabelView = [[UIView alloc]init];
    iconAndLabelView.backgroundColor = [UIColor clearColor];
    iconAndLabelView.size = CGSizeMake(165, 40);
    iconAndLabelView.x = (self.view.width - iconAndLabelView.width)/2;
    iconAndLabelView.y = self.view.height * 0.2;
    [iconAndLabelView addSubview:imageView];
    [iconAndLabelView addSubview:label];
    [self.view addSubview:iconAndLabelView];
    [self.view addSubview:mask];
    
}
- (void)setupBottomBar
{
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height * 0.9, self.view.width, self.view.height * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.x = 5;
    backButton.width = 50;
    backButton.height = 30;
    backButton.y = (bottomBar.height - backButton.height)/2;
    
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:backButton];
    [self.view addSubview:bottomBar];
}
- (void)setupScanWindowView
{
    
    UIView *scanWindow = [[UIView alloc] init];
    scanWindow.width = ScanViewWidthAndHeight;
    scanWindow.height = ScanViewWidthAndHeight;
    scanWindow.y = (self.view.height - scanWindow.height) / 2;
    scanWindow.x =(self.view.width - scanWindow.width)/2;
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    CGFloat scanNetImageViewH = ScanViewWidthAndHeight;
    CGFloat scanNetImageViewW = scanWindow.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindow.height);
    scanNetAnimation.duration = 1.5;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
//  设置4个边框
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindow.width - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindow.height - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(((self.view.height-ScanViewWidthAndHeight)/2)/self.view.height,((self.view.width-ScanViewWidthAndHeight)/2)/self.view.width,ScanViewWidthAndHeight/QKScreenHeight,ScanViewWidthAndHeight/QKScreenWidth);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame= self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    //开始捕获
    [_session startRunning];
    
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        
        AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.isExistenceNetwork == NO) {
            [_session stopRunning];
            [MBProgressHUD showError:@"请检查网络"];
        }else{
            [_session stopRunning];
            AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
            QKWebViewController * webVC = [[QKWebViewController alloc]init];
            QKAnswerViewController * answerVC = [[QKAnswerViewController alloc]init];
            
            webVC.urlStr = metadataObject.stringValue;
//            DCLog(@"扫描结果---%@",metadataObject.stringValue);
            if([metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/math/"]||[metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/english/"]||[metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/chinese/"]){
                NSString * str = metadataObject.stringValue;
                NSString * str2 = [str componentsSeparatedByString:@"com/"].lastObject;
                NSString * str3 =[str2 componentsSeparatedByString:@".p"].firstObject;
                NSString *strUrl = [str3 stringByReplacingOccurrencesOfString:@"/" withString:@""];
//                DCLog(@"拆分字符串-%@",strUrl);
                answerVC.unique_code = strUrl;
                [self.navigationController pushViewController:answerVC animated:YES];
                
            }else{
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"再次扫描", nil];
//        [alert show];
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_session startRunning];
}

-(void)dismiss
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        self.navigationController.navigationBar.hidden = NO;
    }
}


@end
