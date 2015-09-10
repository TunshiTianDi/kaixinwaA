//
//  QKMessageViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKMessageViewController.h"
#import "QKWebViewController.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKMessageContent.h"
#import "QKDataBaseTool.h"
#import "QKMessageCell.h"

@interface QKMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * messages;
@end

@implementation QKMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =  @"我的消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"联系开心蛙" style:UIBarButtonItemStylePlain target:self action:@selector(toContant)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.tintColor = QKColor(108, 108, 108);
    
    UITableView * tableView =[[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = QKGlobalBg;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    self.messages = [QKDataBaseTool lookupTaskTableContent];
}

-(void)toContant
{
    QKWebViewController * connectionVC = [[QKWebViewController alloc]init];
    NSString * phoneNum = [QKAccountTool readAccount].phoneNum;
    NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.163/qkhl_api/index.php/Phone/Contact/index?telephone=%@",phoneNum];
    connectionVC.urlStr = urlStr;
    connectionVC.webName = @"联系开心蛙";
    [self.navigationController pushViewController:connectionVC animated:YES];
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QKMessageCell * cell = [QKMessageCell cellWithTableView:tableView];
    QKMessageContent * message = self.messages[indexPath.row];
    cell.messageContent = message;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
@end
