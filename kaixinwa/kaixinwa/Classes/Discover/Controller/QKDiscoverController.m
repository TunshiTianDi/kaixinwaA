//
//  QKDiscoverController.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/26.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKDiscoverController.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
#import "QKWebViewController.h"
#import "QKTimeLimitDetailViewController.h"
//#import "QKShareTravelViewController.h"
//#import "QKMicroLessonViewController.h"
//#import "QKRadioViewController.h"
//#import "QKGameViewController.h"

@interface QKDiscoverController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView * tableView;
@end

@implementation QKDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QKGlobalBg;
//    [self creatUI];
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.sectionFooterHeight = QKCellMargin;
    tableView.sectionHeaderHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
}

#pragma mark - UITableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"discoverCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(0==indexPath.section){
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"kaixindiantai"]];
            cell.textLabel.text = @"开心电台";
            
        }else if(indexPath.row == 1){
            [cell.imageView setImage:[UIImage imageNamed:@"kaixinwadonghua"]];
            cell.textLabel.text = @"开心蛙动画";
        }
    }else if(1== indexPath.section){
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"kaixinyouxi"]];
            cell.textLabel.text = @"开心游戏";
            
        }else if(indexPath.row == 1){
            [cell.imageView setImage:[UIImage imageNamed:@"kaixinwaduihuan"]];
            cell.textLabel.text = @"开心兑换";
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (0==indexPath.section) {
        if (0==indexPath.row) {
            [self pushWebControllerWithUrl:happyRadioUrl];
            
        }else if (1 == indexPath.row){
            [self pushWebControllerWithUrl:happyVideoUrl];
            
        }
    }else if(1 == indexPath.section){
        if (0==indexPath.row) {
            
            
        }else if (1 == indexPath.row){
            [self pushWebControllerWithUrl:timeLimitUrl];
            
        }
    }

}

-(void)pushWebControllerWithUrl:(NSString*)urlStr
{
    QKAccount * account = [QKAccountTool readAccount];
    
    if ([urlStr isEqualToString:timeLimitUrl]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@/uid/%@/token/%@",urlStr,account.uid,account.token];
        QKTimeLimitDetailViewController *tldVC = [[QKTimeLimitDetailViewController alloc]init];
        tldVC.urlStr = strUrl;
        [self.navigationController pushViewController:tldVC animated:YES];
        
    }else{
        
        NSString *strUrl = [NSString stringWithFormat:@"%@/uid/%@/token/%@",urlStr,account.uid,account.token];
        QKWebViewController * webVc = [[QKWebViewController alloc]init];
        webVc.urlStr = strUrl;
        
        [self.navigationController pushViewController:webVc animated:YES];
    }
}




//-(void)creatUI
//{
//    UIScrollView * sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    sv.showsVerticalScrollIndicator = NO;
//    UIButton * btn = [self creatButtonWithTitle:@"开心微课堂" andImageName:@"lesson" andTag:0];
//    UIButton * btn1 = [self creatButtonWithTitle:@"开心电台" andImageName:@"radio" andTag:1];
//    UIButton * btn2 = [self creatButtonWithTitle:@"开心游学记" andImageName:@"study" andTag:2];
//    UIButton * btn3 = [self creatButtonWithTitle:@"开心游戏" andImageName:@"game" andTag:3];
////    UIButton * btn4 =[self creatButtonWithTitle:@"开心商城" andImageName:@"market" andTag:4];
//    [sv addSubview:btn];
//    [sv addSubview:btn1];
//    [sv addSubview:btn2];
//    [sv addSubview:btn3];
////    [sv addSubview:btn4];
//    sv.contentSize = CGSizeMake(0, self.view.height);
//    [self.view addSubview:sv];
//}
//
//
//-(UIButton *)creatButtonWithTitle:(NSString *)title andImageName:(NSString*)imageName andTag:(NSInteger)tag
//{
//    UIButton * button = [[UIButton alloc]init];
//    button.tag = tag;
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0,  tag * QKScreenWidth/4, QKScreenWidth, QKScreenWidth/4);
//    UILabel * label = [[UILabel alloc]init];
//    label.text = title;
//    label.textColor = QKColor(45, 201, 45);
//    label.font = [UIFont systemFontOfSize:17];
//    label.size = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}];
//    label.frame = CGRectMake(QKScreenWidth - label.width - 20, (button.height - label.height)/2, label.width, label.height);
//    [button addSubview:label];
//    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//-(void)onClick:(UIButton*)sender
//{
//    NSString * urlStr ;
//    QKShareTravelViewController * trv = [[QKShareTravelViewController alloc]init];
//    QKMicroLessonViewController * mlv = [[QKMicroLessonViewController alloc]init];
//    QKRadioViewController * radv=[[QKRadioViewController alloc]init];
//    QKGameViewController * gamev = [[QKGameViewController alloc]init];
//    switch (sender.tag) {
//        case 0:{
//            //开心微课堂
//            urlStr = @"http://182.92.244.120/micro/microclass.html";
//            mlv.urlStr = urlStr;
//            [self.navigationController pushViewController:mlv animated:YES];
//            break;
//        }case 1:{
//            //开心电台
//            urlStr = @"http://101.200.173.111/kaixinwa2.0/index.php/Phone/Radio/index";
//            radv.urlStr = urlStr;
//            [self.navigationController pushViewController:radv animated:YES];
//            break;
//        }case 2:{
//            //开心游学记
//            urlStr = @"http://101.200.173.163/travel/travel.html";
//            trv.urlStr = urlStr;
//            [self.navigationController pushViewController:trv animated:YES];
//            break;
//        }
//        case 3:{
//            //开心游戏
//            urlStr = @"http://101.201.176.9/kxw_game/index.html";
//            gamev.urlStr =urlStr;
//            [self.navigationController pushViewController:gamev animated:YES];
//            break;
//        }
//            
//        default:
//            break;
//    }
//}

@end
