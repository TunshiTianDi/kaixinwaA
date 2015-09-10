//
//  QKDiscoverController.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/26.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKDiscoverController.h"
#import "QKWebViewController.h"
#import "QKShareTravelViewController.h"
#import "QKMicroLessonViewController.h"
#import "QKRadioViewController.h"
#import "QKGameViewController.h"

@interface QKDiscoverController ()

@end

@implementation QKDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
}
-(void)creatUI
{
    UIScrollView * sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    sv.showsVerticalScrollIndicator = NO;
    UIButton * btn = [self creatButtonWithTitle:@"开心微课堂" andImageName:@"lesson" andTag:0];
    UIButton * btn1 = [self creatButtonWithTitle:@"开心电台" andImageName:@"radio" andTag:1];
    UIButton * btn2 = [self creatButtonWithTitle:@"开心游学记" andImageName:@"study" andTag:2];
    UIButton * btn3 = [self creatButtonWithTitle:@"开心游戏" andImageName:@"game" andTag:3];
//    UIButton * btn4 =[self creatButtonWithTitle:@"开心商城" andImageName:@"market" andTag:4];
    [sv addSubview:btn];
    [sv addSubview:btn1];
    [sv addSubview:btn2];
    [sv addSubview:btn3];
//    [sv addSubview:btn4];
    sv.contentSize = CGSizeMake(0, self.view.height);
    [self.view addSubview:sv];
}


-(UIButton *)creatButtonWithTitle:(NSString *)title andImageName:(NSString*)imageName andTag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc]init];
    button.tag = tag;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,  tag * QKScreenWidth/4, QKScreenWidth, QKScreenWidth/4);
    UILabel * label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = QKColor(45, 201, 45);
    label.font = [UIFont systemFontOfSize:17];
    label.size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
    label.frame = CGRectMake(QKScreenWidth - label.width - 20, (button.height - label.height)/2, label.width, label.height);
    [button addSubview:label];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)onClick:(UIButton*)sender
{
    NSString * urlStr ;
    QKShareTravelViewController * trv = [[QKShareTravelViewController alloc]init];
    QKMicroLessonViewController * mlv = [[QKMicroLessonViewController alloc]init];
    QKRadioViewController * radv=[[QKRadioViewController alloc]init];
    QKGameViewController * gamev = [[QKGameViewController alloc]init];
    switch (sender.tag) {
        case 0:{
            //开心微课堂
            urlStr = @"http://182.92.244.120/micro/microclass.html";
            mlv.urlStr = urlStr;
            [self.navigationController pushViewController:mlv animated:YES];
            break;
        }case 1:{
            //开心电台
            urlStr = @"http://101.200.173.163/qkhl_api/index.php/Phone/Radio/index";
            radv.urlStr = urlStr;
            [self.navigationController pushViewController:radv animated:YES];
            break;
        }case 2:{
            //开心游学记
            urlStr = @"http://101.200.173.163/travel/travel.html";
            trv.urlStr = urlStr;
            [self.navigationController pushViewController:trv animated:YES];
            break;
        }
        case 3:{
            //开心游戏
            urlStr = @"http://101.201.176.9/kxw_game/index.html";
            gamev.urlStr =urlStr;
            [self.navigationController pushViewController:gamev animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
