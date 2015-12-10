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
#import "QKMyShareTableViewController.h"
#import "QKBackgroudTool.h"
#import "QKDataBaseTool.h"
#import "QKLoginViewController.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKProfileHVFrame.h"
#import "QKTestViewController.h"
#import "QKRechargeViewController.h"
#import "QKTimeLimitDetailViewController.h"
#import "UIImageView+WebCache.h"

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
    //通知充值成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeFinished:) name:NotifacationSuccessForRecharge object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.refreshControl endRefreshing];
}

#pragma mark -通知方法
-(void)finishSignTask:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    [QKDataBaseTool insertInTaskTableWithTitle:@"您已完成了一项任务" andDetailText:@"恭喜你已经完成每日签到任务，并获得5个开心豆"];
}
-(void)rechargeFinished:(NSNotification*)noti
{
    self.myMessage.badgeValue = @"new";
    [QKGetHappyPeaTool getHappyPeaNum];
    [self.tableView reloadData];
    self.tabBarItem.badgeValue = @"new";
    NSString * detailText = [NSString stringWithFormat:@"成功充值￥%@元,开心豆已添加至账户",noti.userInfo[@"price"]];
    [QKDataBaseTool insertInTaskTableWithTitle:@"开心豆充值成功" andDetailText:detailText];
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
    
    //下载头像
    NSURL * header_url =[NSURL URLWithString:account.header];
    [self.headerView.profileView.icon sd_setImageWithURL:header_url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headerView.profileView.image = [QKBackgroudTool gaussianBlur:image];
        
        [self saveImage:image];
        [self.refreshControl endRefreshing];
    }];
}

-(void)saveImage:(UIImage *)image
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"upload_header.data"];
    // and then we write it out
    //    DCLog(@"路径：%@",fullPathToFile);
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    if(imageData==nil){
        imageData = UIImagePNGRepresentation(image);
    }
    [imageData writeToFile:fullPathToFile atomically:YES];
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
    QKAccount * account = [QKAccountTool readAccount];
    HMCommonGroup* group = [HMCommonGroup group];
    [self.groups addObject:group];
//    HMCommonArrowItem * inviteFriends = [HMCommonArrowItem itemWithTitle:@"邀请好友" icon:[UIImage imageNamed:@"invite_friend"]];
//    inviteFriends.destVcClass = [QKInvateFriendsViewController class];
    
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
    myOrder.operation = ^{
        QKTimeLimitDetailViewController * order = [[QKTimeLimitDetailViewController alloc]init];
        NSString * string = [NSString stringWithFormat:@"%@/uid/%@/token/%@",myOrderUrl,account.uid,account.token];
        order.urlStr = string;
        [wSelf.navigationController pushViewController:order animated:YES];
    };
    
//    我的收藏
//    HMCommonArrowItem * myCollected = [HMCommonArrowItem itemWithTitle:@"我的收藏" icon:[UIImage imageNamed:@"wodeshoucang"]];
//    myCollected.destVcClass = [QKTestViewController class];
    group.items = @[myMessage,myOrder];
    
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
//    NSLog(@"去充值");
    NSString * str = [NSString stringWithFormat:@"http://101.200.173.111/kaixinwa2.0/mall.php/Index/recharge?uid=%@",[QKAccountTool readAccount].uid];
    QKRechargeViewController * webVc = [[QKRechargeViewController alloc]init];
    webVc.urlStr = str;
    [self.navigationController pushViewController:webVc animated:YES];
    
}

- (void)balanceOnClickShopping:(QKBalanceView *)balanceView
{
//    NSLog(@"去商城");
    QKTimeLimitDetailViewController * shop = [[QKTimeLimitDetailViewController alloc]init];
    NSString * string = [NSString stringWithFormat:@"%@/uid/%@/token/%@",timeLimitUrl,[QKAccountTool readAccount].uid,[QKAccountTool readAccount].token];
    shop.urlStr = string;
    [self.navigationController pushViewController:shop animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
