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

@interface QKHomeViewController ()<ImagePlayerViewDelegate>
@property(nonatomic,strong)NSMutableArray * imageUrls;
@property(nonatomic,weak)UIScrollView * scrollView;
@property(nonatomic,weak)ImagePlayerView * imagePlayerView;
@property(nonatomic,weak)QKGridView * exchangeView;
@property(nonatomic,weak)QKRadioView * radioView;
@property(nonatomic,weak)QKGridView * gameView;
@property(nonatomic,weak)QKAnimationView * anView;
@end

@implementation QKHomeViewController
-(NSMutableArray *)imageUrls
{
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaixinwa"]];
    [self creatUI];
    [QKHttpTool post:@"http://test.qkhl-api.com/qkhl_api/index.php/Kxwapi/Index/gethome" params:nil success:^(id responseObj) {
        DCLog(@"%@",responseObj);
        QKFirstHome * home = [QKFirstHome objectWithKeyValues:responseObj];
        for (QKLunbo * lunbo in home.data.lunbo) {
            [self.imageUrls addObject:lunbo.lunbo_faceurl];
        }
        self.exchangeView.items = home.data.goods;
        self.radioView.radio = home.data.radio;
        self.anView.items = home.data.video;
        self.gameView.items = home.data.game;
        [self.imagePlayerView reloadData];
        
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
    }];
    
    
}
-(void)creatUI
{
    UIScrollView * scrollView = [[UIScrollView alloc]init];
//    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //轮播视图
    ImagePlayerView * imagePlayerView = [[ImagePlayerView alloc]init];
    imagePlayerView.backgroundColor = [UIColor cyanColor];
    imagePlayerView.frame = CGRectMake(0, 0, self.view.width, 200);
    imagePlayerView.imagePlayerViewDelegate = self;
    imagePlayerView.scrollInterval = 5.0;
    imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.imagePlayerView = imagePlayerView;
    [scrollView addSubview:imagePlayerView];
    //限时兑换
    QKGridView * exchangeView = [[QKGridView alloc]init];
    exchangeView.title = @"限时兑换";
    exchangeView.moreBtnTag = 1;
    exchangeView.x = 0;
    exchangeView.y = QKCellMargin + imagePlayerView.height;
    exchangeView.width = QKScreenWidth;
    exchangeView.height = QKCellHeight;
    self.exchangeView = exchangeView;
    [scrollView addSubview:exchangeView];
    //开心电台
    QKRadioView * radioView = [[QKRadioView alloc]init];
    radioView.title = @"开心电台";
    radioView.x = 0;
    radioView.y = CGRectGetMaxY(exchangeView.frame);
    radioView.width = QKScreenWidth;
    radioView.height = QKCellHeight;
    [scrollView addSubview:radioView];
    self.radioView = radioView;
    //开心蛙动画
    QKAnimationView * anView = [[QKAnimationView alloc]init];
    anView.title = @"开心蛙动画";
    anView.x = 0;
    anView.y = CGRectGetMaxY(radioView.frame);
    anView.width = QKScreenWidth;
    anView.height = QKCellHeight;
    [scrollView addSubview:anView];
    self.anView = anView;
    
    //开心益智游戏
    QKGridView *gameView = [[QKGridView alloc]init];
    gameView.title = @"开心益智游戏";
    gameView.moreBtnTag = 2;
    gameView.x = exchangeView.x;
    gameView.y = CGRectGetMaxY(anView.frame);
    gameView.width = QKScreenWidth;
    gameView.height = QKCellHeight;
    [scrollView addSubview:gameView];
    self.gameView = gameView;
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(gameView.frame));
    
}
//设置轮播视图代理
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageUrls.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:index]] placeholderImage:nil];
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    DCLog(@"did tap index = %d", (int)index);
}



@end
