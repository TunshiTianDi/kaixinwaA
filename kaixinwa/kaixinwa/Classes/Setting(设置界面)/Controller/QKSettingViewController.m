//
//  QKSettingViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKSettingViewController.h"
#import "QKCommonItemHeader.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKLoginViewController.h"
#import "QKAboutKaixinwaViewController.h"
#import "MBProgressHUD+MJ.h"
#import "SDImageCache.h"
#import "QKDataBaseTool.h"

@interface QKSettingViewController ()<UIAlertViewDelegate>
@property(nonatomic,copy)NSURL * trackViewUrl;
@end

@implementation QKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.bounces = NO;
    
    [self setupGroups];
    [self setupFooter];
}

-(void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
    
}

-(void)setupGroup0
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonSwitchItem * switchItem = [HMCommonSwitchItem itemWithTitle:@"消息推送提醒"];
    
    switchItem.on = YES;
    
    HMCommonArrowItem * clearItem = [HMCommonArrowItem itemWithTitle:@"清除图片缓存"];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * imageCachePath = [caches stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    long long fileSize = [self fileSizeAtFile:imageCachePath];
    int value = [NSString stringWithFormat:@"(%.1fK)", fileSize / 1000.0].intValue;
    
    clearItem.subtitle = value < 1024 ?[NSString stringWithFormat:@"(%.1fK)", fileSize / 1000.0]:[NSString stringWithFormat:@"(%.1fM)", fileSize / 1000.0 * 1000];
    __weak typeof(clearItem) weakClearCache = clearItem;
    __weak typeof(self) weakVc = self;
    clearItem.operation = ^{
        [MBProgressHUD showMessage:@"正在清除缓存...."];
        
        // 清除缓存
        NSFileManager *mgr = [NSFileManager defaultManager];
        [mgr removeItemAtPath:imageCachePath error:nil];
        
        // 设置subtitle
        weakClearCache.subtitle = nil;
        [QKDataBaseTool cleanAllTaskMessage];
        // 刷新表格
        [weakVc.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    };
    group.items = @[switchItem,clearItem];
}

-(void)setupGroup1
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonArrowItem * aboutAnswer = [HMCommonArrowItem itemWithTitle:@"关于开心蛙答案"];
    aboutAnswer.destVcClass = [QKAboutKaixinwaViewController class];
    
    //    HMCommonArrowItem * update = [HMCommonArrowItem itemWithTitle:@"检查更新"];
    //    DCLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
    //    update.operation = ^{
    //
    ////        [self startCheckUpdate];
    //
    //    };
    
    group.items = @[aboutAnswer];
}

- (void)setupFooter
{
    //创建容器
    UIView * btnView = [[UIView alloc]init];
    btnView.height = 43;
    btnView.width = self.view.width;
    btnView.x = 0;
    btnView.y = 0;
    // 1.创建按钮
    UIButton *logout = [[UIButton alloc] init];
    
    // 2.设置属性
    logout.titleLabel.font = [UIFont systemFontOfSize:15];
    [logout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"cancel_button_unclicked"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage resizedImage:@"cancel_button_clicked"] forState:UIControlStateHighlighted];
    
    // 3.设置尺寸(tableFooterView和tableHeaderView的宽度跟tableView的宽度一样)
    logout.height = btnView.height;
    logout.width = btnView.width - 2 * QKCellMargin;
    logout.x = QKCellMargin;
    logout.y = 0;
    
    // 4.添加点击事件
    [logout addTarget:self action:@selector(logoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:logout];
    self.tableView.tableFooterView = btnView;
}
-(void)logoutButton:(UIButton *)button
{
    DCLog(@"点击退出");
    [MBProgressHUD showMessage:@"正在退出"];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5];
    
}
-(void)delayMethod
{
    [QKAccountTool deleteAccount];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    QKLoginViewController* loginVc = [[QKLoginViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [MBProgressHUD hideHUD];
    window.rootViewController = nav;
}

- (long long)fileSizeAtFile:(NSString *)file
{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:file isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:file error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [file stringByAppendingPathComponent:subpath];
            totalSize += [self fileSizeAtFile:fullSubpath];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:file error:nil];
        return [attr[NSFileSize] longLongValue];
    }
    
    // 只能获得当前文件夹里面的子文件\子文件夹
    //    NSArray *contents = [mgr contentsOfDirectoryAtPath:file error:nil];
}

//检查更新
/*
 -(void)startCheckUpdate
 {
 NSString * appID = [NSBundle mainBundle].bundleIdentifier;
 NSError * error;
 NSString * urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appID];
 NSURL * url = [NSURL URLWithString:urlStr];
 NSURLRequest * request = [NSURLRequest requestWithURL:url];
 NSData * response =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSDictionary * appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
 if (error) {
 DCLog(@"%@",error);
 
 }
 NSArray * resultArray = [appInfoDic objectForKey:@"results"];
 if (![resultArray count]) {
 DCLog(@"resultArray = nil");
 
 }
 NSDictionary * infoDic = [resultArray objectAtIndex:0];
 NSString * lastVersion = [infoDic objectForKey:@"version"];
 NSURL * trackViewUrl = [infoDic objectForKey:@"trackViewUrl"];
 NSString * trackName = [infoDic objectForKey:@"trackName"];
 self.trackViewUrl = trackViewUrl;
 
 NSDictionary * infoDict =[[NSBundle mainBundle]infoDictionary];
 NSString * currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
 
 double doubleCurrentVersion = [currentVersion doubleValue];
 double doubleUpdataVersion = [lastVersion doubleValue];
 if (doubleCurrentVersion < doubleUpdataVersion) {
 NSString * titleStr = [NSString stringWithFormat:@"检查更新，%@",trackName];
 NSString * messageStr = [NSString stringWithFormat:@"发现新版本（%@），是否升级",lastVersion];
 UIAlertView * alv = [[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
 alv.tag = 1;
 [alv show];
 }else{
 NSString * titleStr = [NSString stringWithFormat:@"检查更新，%@",trackName];
 UIAlertView * alv = [[UIAlertView alloc]initWithTitle:titleStr message:@"暂无新版本" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
 alv.tag = 2;
 [alv show];
 }
 }
 
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (alertView.tag == 1) {
 if (buttonIndex == 1) {
 [[UIApplication sharedApplication] openURL:self.trackViewUrl];
 }
 }
 alertView = nil;
 }
 */
@end
