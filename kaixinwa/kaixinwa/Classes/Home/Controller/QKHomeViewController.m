//
//  QKHomeViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//
#define ScanViewWidthAndHeight QKScreenWidth * 0.6
#define QKScreenHeight [UIScreen mainScreen].bounds.size.height
#define QKCellHeight 160


#import "QKHomeViewController.h"
#import "QKQRCodeViewController.h"
#import "QKHttpTool.h"
#import "MJExtension.h"
#import "ImagePlayerView.h"
#import "QKFirstHome.h"
#import "QKLunbo.h"
#import "UIImageView+WebCache.h"
#import "QKGridView.h"
#import "QKRadioView.h"
#import "QKAnimationView.h"
#import "QKWebViewController.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
#import "MBProgressHUD+MJ.h"
#import "QKGetHappyPeaTool.h"
#import "QKSignResult.h"
#import "QKLoginViewController.h"
#import "QKTimeLimitDetailViewController.h"
#import "QKHappyVideoController.h"

@interface QKHomeViewController ()<ImagePlayerViewDelegate>
@property(nonatomic,strong)NSMutableArray * imageUrls;
@property(nonatomic,strong)NSMutableArray * lunboDesUrls;
@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,weak)ImagePlayerView * imagePlayerView;
@property(nonatomic,weak)QKGridView * exchangeView;
@property(nonatomic,weak)QKRadioView * radioView;
@property(nonatomic,weak)QKGridView * gameView;
@property(nonatomic,weak)QKAnimationView * anView;
@property(nonatomic,weak)UIRefreshControl * refreshControl;
@end

@implementation QKHomeViewController
-(NSMutableArray *)imageUrls
{
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}
-(NSMutableArray *)lunboDesUrls
{
    if (!_lunboDesUrls) {
        _lunboDesUrls = [NSMutableArray array];
    }
    return _lunboDesUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaixinwa"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"meiriqiandao" highImageName:@"meiriqiandao_sel" target:self action:@selector(signEveryday:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"huoqudaan" highImageName:@"huoqudaan_sel" target:self action:@selector(toScanView)];
    
    [self creatUI];
    
    //发送请求获取首页数据
    [QKHttpTool post:@"http://101.200.173.111/kaixinwa2.0/index.php/Kxwapi/Index/getHome" params:nil success:^(id responseObj) {
        DCLog(@"%@",responseObj);
        QKFirstHome * home = [QKFirstHome objectWithKeyValues:responseObj];
        for (QKLunbo * lunbo in home.data.lunbo) {
            [self.imageUrls addObject:lunbo.lunbo_faceurl];
            [self.lunboDesUrls addObject:lunbo.lunbo_des_url];
        }
        self.exchangeView.items = home.data.goods;
        self.radioView.radio = home.data.radio;
        self.anView.items = home.data.video;
        self.gameView.items = home.data.game;
        [self.imagePlayerView reloadData];
        
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
        [MBProgressHUD showError:@"请求失败..."];
    }];
    
    [self registNotifications];
}
-(void)registNotifications
{
    //注册通知处理点击游戏图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameMethod:) name:NotifacationToSkipGameWeb object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameMore:) name:NotifacationToSkipGameMore object:nil];
    //注册通知处理点击限时兑换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapGood:) name:NotifacationToSkipTimeLimit object:nil];
    //注册通知处理限时兑换显示更多
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapGoodMore:) name:NotifacationToSkipTimeLimitMore object:nil];
    //注册通知开心动画处理显示更多
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapMoreVideo:) name:NotifacationToSkipAnimation object:nil];
    //注册通知开心动画具体
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapVideo:) name:NotifacationToSkipAnimationDetail object:nil];
    //注册通知开心电台具体
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapRadio:) name:NotifacationToSkipRadio object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapMore:) name:NotifacationToSkipRadioMore object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.refreshControl endRefreshing];
}
#pragma mark - NavigationItem点击事件
-(void)toScanView
{
    QKQRCodeViewController * qrVC = [[QKQRCodeViewController alloc]init];
    [self.navigationController pushViewController:qrVC animated:YES];
}
-(void)signEveryday:(UIBarButtonItem*)item
{
    //签到方法
    QKAccount* account = [QKAccountTool readAccount];
    if (account) {
        if (account.lasttime) {
            //发送签到请求
            NSDictionary * param = @{@"uid":account.uid};
            [QKHttpTool post:SignEverydayInterface params:param success:^(id responseObj) {
                QKSignResult * signResult =[QKSignResult objectWithKeyValues:responseObj];
                NSString * code = [signResult.code stringValue];
                //更新账号信息
                if ([code isEqualToString:@"201"]) {
                    account.lasttime = signResult.data.lasttime;
                    [QKAccountTool save:account];
                    [MBProgressHUD showSuccess:signResult.message];
                    [QKGetHappyPeaTool getHappyPeaNum];
                    //发送通知完成签到任务
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishSignTask" object:nil];
                }else{
                    [MBProgressHUD showError:signResult.message];
                }
            } failure:^(NSError *error) {
                DCLog(@"----%@",error);
            }];
        }else{
            [MBProgressHUD showError:@"已签到"];
        };
    }else{
        [self skipLoginViewController];
    }
    
    
}
#pragma mark - 通知方法
-(void)gameMethod:(NSNotification *)noti
{
    QKWebViewController * wvc = [[QKWebViewController alloc]init];
    NSString * url = noti.userInfo[GameKey];
    wvc.urlStr = url;
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)gameMore:(NSNotification *)noti
{
    QKWebViewController * wvc = [[QKWebViewController alloc]init];
    NSString * url = noti.userInfo[@"url"];
    wvc.urlStr = url;
    [self.navigationController pushViewController:wvc animated:YES];
}
-(void)tapGood:(NSNotification *)noti
{
    QKAccount * account = [QKAccountTool readAccount];
    if(account){
        QKTimeLimitDetailViewController * tldVc = [[QKTimeLimitDetailViewController alloc]init];
        NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.111/kaixinwa2.0/mall.php/Index/details/id/%@/source/1/uid/%@/token/%@",noti.userInfo[@"gid"],account.uid,account.token];
        tldVc.urlStr = urlStr;
        
        [self.navigationController pushViewController:tldVc animated:YES];
    }else{
        [self skipLoginViewController];
    }
}

-(void)tapGoodMore:(NSNotification *)noti
{
    QKAccount * account = [QKAccountTool readAccount];
    QKTimeLimitDetailViewController * web = [[QKTimeLimitDetailViewController alloc]init];
    NSString * strAll = [NSString stringWithFormat:@"%@/uid/%@/token/%@",noti.userInfo[@"url"],account.uid,account.token];
    web.urlStr = strAll;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)tapMore:(NSNotification *)noti
{
    QKAccount * account = [QKAccountTool readAccount];
    QKWebViewController * web = [[QKWebViewController alloc]init];
    NSString * strAll = [NSString stringWithFormat:@"%@/uid/%@/token/%@",noti.userInfo[@"url"],account.uid,account.token];
    web.urlStr = strAll;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)tapMoreVideo:(NSNotification *)noti
{
    QKAccount * account = [QKAccountTool readAccount];
    QKHappyVideoController * web = [[QKHappyVideoController alloc]init];
     NSString * strAll = [NSString stringWithFormat:@"%@/Index/index/uid/%@/token/%@",noti.userInfo[@"url"],account.uid,account.token];
    web.urlStr = strAll;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)tapVideo:(NSNotification *)noti
{
    QKHappyVideoController * webV = [[QKHappyVideoController alloc]init];
    NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.111/kaixinwa2.0/video.php/Play/index/roomtypeid/%@/uid/%@/token/%@/type/%@",noti.userInfo[@"vid"],[QKAccountTool readAccount].uid,[QKAccountTool readAccount].token,noti.userInfo[@"type"]];
    webV.urlStr = urlStr;
    [self.navigationController pushViewController:webV animated:YES];
    
}
-(void)tapRadio:(NSNotification *)noti
{
    QKWebViewController * webV = [[QKWebViewController alloc]init];
    NSString * urlStr = [NSString stringWithFormat:@"http://101.200.173.111/kaixinwa2.0/phone.php/Radio/detail/id/%@/uid/%@/token/%@",noti.userInfo[@"id"],[QKAccountTool readAccount].uid,[QKAccountTool readAccount].token];
    webV.urlStr = urlStr;
    [self.navigationController pushViewController:webV animated:YES];
}

#pragma mark - 首页控件
-(void)creatUI
{
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = QKGlobalBg;
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //轮播视图
    ImagePlayerView * imagePlayerView = [[ImagePlayerView alloc]init];
    
//    imagePlayerView.backgroundColor = [UIColor cyanColor];
    imagePlayerView.frame = CGRectMake(0, 0, self.view.width, 160);
    imagePlayerView.imagePlayerViewDelegate = self;
    imagePlayerView.scrollInterval = 5.0;
    imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    imagePlayerView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    imagePlayerView.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    self.imagePlayerView = imagePlayerView;
    [scrollView addSubview:imagePlayerView];
    
    //限时兑换
    QKGridView * exchangeView = [[QKGridView alloc]init];
    exchangeView.title = @"限时兑换";
    exchangeView.moreBtnTag = 1;
    exchangeView.x = 0;
    exchangeView.y = QKCellMargin + imagePlayerView.height;
    exchangeView.width = QKScreenWidth;
    exchangeView.height = ISLessThanFourInch ? 150 : QKCellHeight;
    self.exchangeView = exchangeView;
    [scrollView addSubview:exchangeView];
    //开心电台
    QKRadioView * radioView = [[QKRadioView alloc]init];
    radioView.title = @"开心电台";
    radioView.x = 0;
    radioView.y = CGRectGetMaxY(exchangeView.frame);
    radioView.width = QKScreenWidth;
    radioView.height = ISLessThanFourInch ? 150 : QKCellHeight;
    [scrollView addSubview:radioView];
    self.radioView = radioView;
    //开心蛙动画
    QKAnimationView * anView = [[QKAnimationView alloc]init];
    anView.title = @"开心蛙动画";
    anView.x = 0;
    anView.y = CGRectGetMaxY(radioView.frame);
    anView.width = QKScreenWidth;
    anView.height = ISLessThanFourInch ? 140 : QKCellHeight;
    [scrollView addSubview:anView];
    self.anView = anView;
    
    //开心益智游戏
    QKGridView *gameView = [[QKGridView alloc]init];
    gameView.title = @"开心益智游戏";
    gameView.moreBtnTag = 2;
    gameView.x = exchangeView.x;
    gameView.y = CGRectGetMaxY(anView.frame);
    gameView.width = QKScreenWidth;
    gameView.height = ISLessThanFourInch ? 140 : QKCellHeight;
    [scrollView addSubview:gameView];
    self.gameView = gameView;
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(gameView.frame));
    //下拉刷新
    UIRefreshControl * refreshControl = [[UIRefreshControl alloc]init];
//    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"开始刷新"];
    [scrollView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshHomeData:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}
//下拉刷新
-(void)refreshHomeData:(UIRefreshControl *)refreshControl
{
    [refreshControl beginRefreshing];
    [self.imageUrls removeAllObjects];
    [self.lunboDesUrls removeAllObjects];
    //发送请求获取首页数据
    [QKHttpTool post:@"http://101.200.173.111/kaixinwa2.0/index.php/Kxwapi/Index/getHome" params:nil success:^(id responseObj) {
        QKFirstHome * home = [QKFirstHome objectWithKeyValues:responseObj];
        for (QKLunbo * lunbo in home.data.lunbo) {
            [self.imageUrls addObject:lunbo.lunbo_faceurl];
            [self.lunboDesUrls addObject:lunbo.lunbo_des_url];
        }
        self.exchangeView.items = home.data.goods;
        self.radioView.radio = home.data.radio;
        self.anView.items = home.data.video;
        self.gameView.items = home.data.game;
        [self.imagePlayerView reloadData];
        [refreshControl endRefreshing];
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
        [refreshControl endRefreshing];
    }];
    
}

//设置轮播视图代理
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageUrls.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    DCLog(@"did tap index = %@", self.lunboDesUrls[index]);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)skipLoginViewController
{
    QKLoginViewController* loginVc = [[QKLoginViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
