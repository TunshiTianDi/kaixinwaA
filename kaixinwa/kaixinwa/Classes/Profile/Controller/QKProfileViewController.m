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
#import "QKLoginViewController.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKProfileHVFrame.h"
#import "QKTestViewController.h"
#import "QKRechargeViewController.h"

@interface QKProfileViewController ()
@property(nonatomic,strong)QKProfileHeaderView * headerView;
@property(nonatomic,strong)HMCommonArrowItem * myMessage;
@end

@implementation QKProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaixinwa"]];
    QKAccount * account = [QKAccountTool readAccount];
    [self setupHeaderView];
    [self setupGroups];
    if (account) {
        [self setupRefresh];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"shezhi" highImageName:@"shezhi" target:self action:@selector(setting)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        //获取开心豆数量
        [QKGetHappyPeaTool getHappyPeaNum];
    }
    
    //通知完成任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSignTask:) name:@"finishSignTask" object:nil];
}


#pragma mark -通知方法
-(void)finishSignTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成了一项任务" andDetailText:@"恭喜你已经完成每日签到任务，并获得5个开心豆"];
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
    QKAccount * account = [QKAccountTool readAccount];
    //获取开心豆数量
    [QKGetHappyPeaTool getHappyPeaNum];
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
    QKAccount * account = [QKAccountTool readAccount];
    QKProfileHVFrame * profileHVFrame = [[QKProfileHVFrame alloc]init];
    profileHVFrame.account = account;
    headerView.profileHVFrame = profileHVFrame;
    headerView.frame = profileHVFrame.frame;
    
    self.headerView = headerView;
    //设置delegate
    headerView.balanceView.delegate = self;
    headerView.profileView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

- (void)setupGroups
{
    [self setupGroup1];
}

-(void)setupGroup1
{
//    QKAccount * account = [QKAccountTool readAccount];
    HMCommonGroup* group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonArrowItem * inviteFriends = [HMCommonArrowItem itemWithTitle:@"邀请好友" icon:[UIImage imageNamed:@"invite_friend"]];
    inviteFriends.destVcClass = [QKInvateFriendsViewController class];
    
    //我的消息
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
    //我的订单
    HMCommonArrowItem * myOrder = [HMCommonArrowItem itemWithTitle:@"我的订单" icon:[UIImage imageNamed:@"wodedingdan"]];
    myOrder.destVcClass = [QKTestViewController class];
    
//    我的收藏
    HMCommonArrowItem * myCollected = [HMCommonArrowItem itemWithTitle:@"我的收藏" icon:[UIImage imageNamed:@"wodeshoucang"]];
    myCollected.destVcClass = [QKTestViewController class];
    group.items = @[myMessage,myOrder,inviteFriends,myCollected];
    
}

#pragma mark - 处理profileView中代理方法
- (void)tapProfileImage:(QKProfileView *)profileView
{
    QKAccount * account =[QKAccountTool readAccount];
    if (account) {
        QKModifyUserInfoViewController * modify =[[QKModifyUserInfoViewController alloc]init];
        modify.avatarImage = profileView.icon.image;
        [self.navigationController pushViewController:modify animated:YES];
    }else{
        QKLoginViewController * loginVc = [[QKLoginViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
}
#pragma mark - 处理balanceView的代理方法
- (void)balanceOnClickRecharge:(QKBalanceView *)balanceView
{
    NSLog(@"去充值");
    NSString * str = [NSString stringWithFormat:@"http://192.168.1.19/mall.php/index/recharge?uid=%@",[QKAccountTool readAccount].uid];
    QKRechargeViewController * webVc = [[QKRechargeViewController alloc]init];
    webVc.urlStr = str;
    [self.navigationController pushViewController:webVc animated:YES];
    
}

- (void)balanceOnClickShopping:(QKBalanceView *)balanceView
{
    NSLog(@"去商城");
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
