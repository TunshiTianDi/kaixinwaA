//
//  QKTabBarController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKTabBarController.h"
#import "QKHomeViewController.h"
#import "QKProfileViewController.h"
#import "QKNavigationController.h"
#import "QKDiscoverController.h"

@interface QKTabBarController ()

@end

@implementation QKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    //创建视图控制器
    QKHomeViewController*home =[[QKHomeViewController alloc]init];
    
    QKDiscoverController * discover = [[QKDiscoverController alloc]init];
    QKProfileViewController * profile = [[QKProfileViewController alloc]init];
    
    [self addOneChildVc:home title:@"首页" imageName:@"home" selectedImageName:@"home_sel"];
    [self addOneChildVc:discover title:@"发现" imageName:@"faxian" selectedImageName:@"faxi_sel"];
    [self addOneChildVc:profile title:@"我" imageName:@"wd" selectedImageName:@"wde"];
    
    
    
}
-(void)addOneChildVc:(UIViewController*)childVc title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName

{
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = QKColor(127, 127, 127);
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = QKColor(45, 201, 45);
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    //设置选中图标
    UIImage * selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    
    //添加导航控制器
    QKNavigationController * nav = [[QKNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
}

@end
