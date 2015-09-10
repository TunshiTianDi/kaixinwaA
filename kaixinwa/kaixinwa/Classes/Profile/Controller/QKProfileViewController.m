//
//  QKProfileViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKProfileViewController.h"
#import "QKCommonItemHeader.h"
#import "QKMyTeskViewController.h"
#import "QKSettingViewController.h"
#import "QKProfileHeaderView.h"
#import "QKModifyUserInfoViewController.h"
#import "QKMessageViewController.h"
#import "QKGetHappyPeaTool.h"
#import "QKPutinInvateCodeVC.h"
#import "QKInvateFriendsViewController.h"
#import "QKMyShareTableViewController.h"
#import "QKBackgroudTool.h"
#import "QKDataBaseTool.h"

@interface QKProfileViewController ()
@property(nonatomic,strong)QKProfileHeaderView * headerView;
@property(nonatomic,strong)HMCommonArrowItem * myMessage;
@end

@implementation QKProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaixinwa"]];
    
    [self setupHeaderView];
    [self setupGroups];
    [self setupRefresh];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"settings_icon" highImageName:@"settings_icon-2" target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    //获取开心豆数量
    [QKGetHappyPeaTool getHappyPeaNum];
    //通知完成任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSignTask:) name:@"finishSignTask" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishBondQQTask:) name:@"finishBondQQ" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishBondWXTask:) name:@"finishBondWeChat" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishUpdateSchoolTask:) name:@"finishUpdateSchool" object:nil];
}
#pragma mark -通知方法
-(void)finishSignTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成了一项任务" andDetailText:@"恭喜你已经完成每日签到任务，并获得5个开心豆"];
}
-(void)finishBondQQTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成一项任务" andDetailText:@"恭喜你已经完成绑定QQ任务,并获得5个开心豆"];
}
-(void)finishBondWXTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成一项任务" andDetailText:@"恭喜你已经完成绑定微信任务,并获得5个开心豆"];
}
-(void)finishUpdateSchoolTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成一项任务" andDetailText:@"恭喜你已经完成填写学校信息任务,并获得10个开心豆"];
}
#pragma mark -下拉刷新
-(void)setupRefresh
{
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
}
/**
 *  当下拉刷新控件进入刷新状态（转圈圈）的时候会自动调用
 */
- (void)refreshControlStateChange:(UIRefreshControl *)refreshControl
{
    [self.refreshControl beginRefreshing];
    //获取开心豆数量
    [QKGetHappyPeaTool getHappyPeaNum];
    
    QKAccount * account = [QKAccountTool readAccount];
    NSString * fileName = [QKHttpTool md5HexDigest:account.phoneNum];
    fileName = [fileName stringByAppendingPathExtension:@"png"];
    NSURL * iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://kaixinwaavatar.oss-cn-beijing.aliyuncs.com/%@",fileName]];
    //下载头像
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data =[NSData dataWithContentsOfURL:iconURL];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //结束刷新
                [self.refreshControl endRefreshing];
                
                self.headerView.profileView.icon.image = [UIImage imageWithData:data];
                //设置背景
                self.headerView.profileView.image = [QKBackgroudTool gaussianBlur:self.headerView.profileView.icon.image];
                if (![[QKUserDefaults objectForKey:@"upload"] isEqualToString:@"hadUpload"]) {
                    //储存头像到本地
                    NSString * iconPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    iconPath = [iconPath stringByAppendingPathComponent:fileName];
                    [data writeToFile:iconPath atomically:YES];
                    [QKUserDefaults setObject:@"hadUpload" forKey:@"upload"];
                    [QKUserDefaults synchronize];
                }else{
                    //储存头像到本地
                    NSString * iconPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    iconPath = [iconPath stringByAppendingPathComponent:fileName];
                    [data writeToFile:iconPath atomically:YES];
                }
            }else{
                self.headerView.profileView.icon.image = [UIImage imageNamed:@"change_avatar-1"];
                [self.refreshControl endRefreshing];
            }
        });
    });
    
}
#pragma mark - 设置UI
-(void)setting
{
    QKSettingViewController * setting = [[QKSettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)setupHeaderView
{
    QKProfileHeaderView * headerView = [[QKProfileHeaderView alloc]init];
    //设置frame
    headerView.x = 0;
    headerView.y = 0;
    headerView.width = QKScreenWidth;
    headerView.height = 244;
    self.headerView = headerView;
    //设置delegate
    //    headerView.balanceView.delegate = self;
    headerView.profileView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

- (void)setupGroups
{
    [self setupGroup0];
//    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}

-(void)setupGroup0
{
    HMCommonGroup* group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem * mytest = [HMCommonArrowItem itemWithTitle:@"我的任务" icon:[UIImage imageNamed:@"my_tasks"]];
    
    mytest.destVcClass = [QKMyTeskViewController class];
    
    HMCommonArrowItem * myShare = [HMCommonArrowItem itemWithTitle:@"我的分享" icon:[UIImage imageNamed:@"my_share"]];
    myShare.destVcClass = [QKMyShareTableViewController class];
    
    group.items = @[mytest,myShare];
}

//-(void)setupGroup1
//{
//    HMCommonGroup* group = [HMCommonGroup group];
//    [self.groups addObject:group];
//    HMCommonArrowItem * shopping = [HMCommonArrowItem itemWithTitle:@"购物车"];
//    
//    HMCommonArrowItem * myOrder = [HMCommonArrowItem itemWithTitle:@"我的订单"];
//    group.items = @[shopping,myOrder];
//}

-(void)setupGroup2
{
    HMCommonGroup* group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonArrowItem * inviteFriends = [HMCommonArrowItem itemWithTitle:@"邀请好友" icon:[UIImage imageNamed:@"invite_friend"]];
    inviteFriends.destVcClass = [QKInvateFriendsViewController class];
    
    
    HMCommonArrowItem * myMessage = [HMCommonArrowItem itemWithTitle:@"我的消息" icon:[UIImage imageNamed:@"my_message"]];
    self.myMessage = myMessage;
    __weak typeof(myMessage) wMessage = myMessage;
    __weak typeof(self) wSelf = self;
    myMessage.operation = ^{
        wMessage.badgeValue = nil;
        wSelf.tabBarItem.badgeValue = nil;
        [wSelf.tableView reloadData];
    };
    myMessage.destVcClass = [QKMessageViewController class];
    group.items = @[myMessage ,inviteFriends];
    
}
-(void)setupGroup3
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonArrowItem * writeInviteCode = [HMCommonArrowItem itemWithTitle:@"填写邀请码" icon:[UIImage imageNamed:@"input_invite_code"]];
    writeInviteCode.destVcClass = [QKPutinInvateCodeVC class];
    
    group.items = @[writeInviteCode];
}

//#pragma mark - 处理balanceView中代理方法
//- (void)balanceOnClickRecharge:(QKBalanceView *)balanceView
//{
//    DCLog(@"去充值");
//}
//
//- (void)balanceOnClickShopping:(QKBalanceView *)balanceView
//{
//    DCLog(@"去商城");
//}

#pragma mark - 处理profileView中代理方法
- (void)tapProfileImage:(QKProfileView *)profileView
{
    DCLog(@"点击头像可以跳转");
    QKModifyUserInfoViewController * modify =[[QKModifyUserInfoViewController alloc]init];
    modify.avatarImage = profileView.icon.image;
    [self.navigationController pushViewController:modify animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
