//
//  QKHomeViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//
#define ScanViewWidthAndHeight QKScreenWidth * 0.6
#define QKScreenHeight [UIScreen mainScreen].bounds.size.height

#import "QKHomeViewController.h"
#import "QKQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QKWebViewController.h"
#import "QKAnswerViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "QKQRScanView.h"

@interface QKHomeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,weak)UIImageView * imageView;
@property(nonatomic,weak)UIView * green;
@property(nonatomic,weak)UIView * red;
@property(nonatomic,strong)AVCaptureSession * session;
@property(nonatomic,weak)QKQRScanView * qrView;
@property(nonatomic,weak)AVCaptureVideoPreviewLayer * layer;
@end

@implementation QKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaixinwa"]];
    [self creatUI];
}
-(void)creatUI
{
    UIImageView * iv = [[UIImageView alloc]init];
    [iv setImage:[UIImage imageNamed:@"saomiaoerweima"]];
    iv.width = 294;
    iv.height = 52;
    iv.centerX = self.view.centerX;
    iv.centerY = self.view.centerY;
    self.imageView = iv;
    [self.view addSubview:iv];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.imageView.hidden == NO){
        self.imageView.hidden = YES;
        QKQRScanView * qrView = [[QKQRScanView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:qrView];
        self.qrView = qrView;
        [self beginScanning];
        
        UIView * green = [[UIView alloc]init];
        green.userInteractionEnabled= YES;
        green.backgroundColor = [UIColor whiteColor];
        green.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
        [self.view addSubview:green];
        self.green = green;
        
        UIView * red = [[UIView alloc]init];
        red.userInteractionEnabled = YES;
        red.backgroundColor = [UIColor whiteColor];
        red.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, green.frame.size.height);
        [self.view addSubview:red];
        self.red = red;
        //    QKQRCodeViewController * scanVc = [[QKQRCodeViewController alloc]init];
        [UIView animateWithDuration:0.75 animations:^{
            self.view.backgroundColor = [UIColor lightGrayColor];
            
            self.green.frame = CGRectMake(0, -self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2);
            
            self.red.frame = CGRectMake(0, self.view.bounds.size.height, self.green.bounds.size.width, self.green.bounds.size.height);
            
        } completion:^(BOOL finished) {
            [red removeFromSuperview];
            [green removeFromSuperview];
            self.red = nil;
            self.green = nil;
            //        [self.navigationController pushViewController:scanVc animated:NO];
        }];
        
        //    [self toSkipScan];
    }
}
//-(void)toSkipScan
//{
//    QKQRCodeViewController * scanVc = [[QKQRCodeViewController alloc]init];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    
//    [self.navigationController pushViewController:scanVc animated:NO];
//    
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//
//}
-(void)viewWillAppear:(BOOL)animated
{
    self.imageView.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.qrView removeFromSuperview];
    [self.layer removeFromSuperlayer];
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
    self.layer =layer;
    
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
            DCLog(@"%@",metadataObject.stringValue);
            if([metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/math/"]||[metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/english/"]||[metadataObject.stringValue hasPrefix:@"http://qkhl-api.com/chinese/"]){
                NSString * str = metadataObject.stringValue;
                NSString * str2 = [str componentsSeparatedByString:@"com/"].lastObject;
                NSString * str3 =[str2 componentsSeparatedByString:@".p"].firstObject;
                NSString *strUrl = [str3 stringByReplacingOccurrencesOfString:@"/" withString:@""];
                DCLog(@"%@",strUrl);
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
@end
