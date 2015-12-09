//
//  QKMyShareTableViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKMyShareTableViewController.h"
#import "QKDataBaseTool.h"
#import "QKMyShareObj.h"
#import "QKShareCell.h"
#import "QKWebViewController.h"
#import "FDActionSheet.h"
#import "MBProgressHUD+MJ.h"

@interface QKMyShareTableViewController ()<FDActionSheetDelegate>

@property(nonatomic,strong)NSMutableArray * shareArray;

@end

@implementation QKMyShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenxiang" highImageName:@"fenxiangsel" target:self action:@selector(cleanAll)];
//    self.shareArray = [QKDataBaseTool lookupTableContent];
    
}
-(void)cleanAll
{
    FDActionSheet * as = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空分享数据", nil];
    [as setButtonTitleColor:QKColor(48, 206, 39) bgColor:nil fontSize:0 atIndex:0];
    [as setCancelButtonTitleColor:[UIColor whiteColor] bgColor:QKColor(48, 206, 39) fontSize:0];
    [as show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            DCLog(@"开始清除");
            [MBProgressHUD showMessage:@"正在清除"];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
            
            break;
        
        default:
            break;
    }

}
-(void)delayMethod
{
    self.shareArray = nil;
    [self.tableView reloadData];
    [MBProgressHUD hideHUD];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.shareArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QKShareCell *cell = [QKShareCell cellWithTableView:tableView];
    // Configure the cell...
    QKMyShareObj * myshare = self.shareArray[indexPath.row];
    cell.myShare = myshare;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QKMyShareObj * myshare = self.shareArray[indexPath.row];
    QKWebViewController * wvc = [[QKWebViewController alloc]init];
    wvc.urlStr = myshare.shareUrl;
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
