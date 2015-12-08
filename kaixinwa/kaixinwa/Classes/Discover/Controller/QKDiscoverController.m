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
#import "QKHttpTool.h"
#import "QKUploadIconTool.h"
#import "QKHappyVideoController.h"

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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
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
            [self pushWebControllerWithUrl:happyGameUrl];
            
        }else if (1 == indexPath.row){
            [self pushWebControllerWithUrl:timeLimitUrl];
            
        }
    }
    
    //点击完毕清除效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)pushWebControllerWithUrl:(NSString*)urlStr
{
    QKAccount * account = [QKAccountTool readAccount];
    
    if ([urlStr isEqualToString:timeLimitUrl]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@/uid/%@/token/%@",urlStr,account.uid,account.token];
        QKTimeLimitDetailViewController *tldVC = [[QKTimeLimitDetailViewController alloc]init];
        tldVC.urlStr = strUrl;
        [self.navigationController pushViewController:tldVC animated:YES];
        
    }else if([urlStr isEqualToString:happyGameUrl]){
        QKWebViewController * webVc = [[QKWebViewController alloc]init];
        webVc.urlStr = urlStr;
        
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else{
        NSString *strUrl = [NSString stringWithFormat:@"%@/uid/%@/token/%@",urlStr,account.uid,account.token];
        QKHappyVideoController * webVc = [[QKHappyVideoController alloc]init];
        webVc.urlStr = strUrl;
        
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

@end
