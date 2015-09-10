//
//  NewfeatureViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/14.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "QKTabBarController.h"

#define QKNewfeatureImageCount 3

@interface NewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    [self setupPageControl];
}

- (void)setupScrollView
{
    // 1.添加UISrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i<QKNewfeatureImageCount; i++) {
        // 创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"newfeature-%d", i + 1];
//        if (FourInch) { // 4inch  需要手动去加载4inch对应的-568h图片
//            name = [name stringByAppendingString:@"-568h"];
//        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 设置frame
        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i * imageW;
        
        // 给最后一个imageView添加按钮
        if (i == QKNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置其他属性
    scrollView.contentSize = CGSizeMake(QKNewfeatureImageCount * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = QKColor(246, 246, 246);

}
/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = QKNewfeatureImageCount;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.centerY = self.view.height - 70;
    [self.view addSubview:pageControl];
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = QKColor(106, 179, 60); // 当前页的小圆点颜色
    pageControl.pageIndicatorTintColor = QKColor(166, 166, 166); // 非当前页的小圆点颜色
    self.pageControl = pageControl;
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    // 1.添加开始按钮
    [self setupStartButton:imageView];
}
/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    // 2.设置背景图片
    [startButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"button-hignlight"] forState:UIControlStateHighlighted];
    
    // 3.设置frame
    startButton.size = startButton.currentBackgroundImage.size;
    startButton.centerX = self.view.width * 0.5;
    startButton.y = self.view.height - startButton.height-QKCellMargin*2;
    
    // 4.设置文字
    [startButton setTitle:@"开始应用" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
 *  开启应用
 */
- (void)startApp
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    // 显示主控制器（QKTabBarController）
    QKTabBarController *vc = [[QKTabBarController alloc] init];
    
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    
    // 设置页码
    self.pageControl.currentPage = intPage;
}


@end
