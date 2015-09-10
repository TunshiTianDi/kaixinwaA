//
//  QKNavigationController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/28.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKNavigationController.h"
#import "FDActionSheet.h"
@interface QKNavigationController ()<FDActionSheetDelegate>

@end

@implementation QKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fanhui" highImageName:@"jiantousel" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenxiang" highImageName:@"fenxiangsel" target:self action:@selector(more)];
    }
    
    [super pushViewController:viewController animated:animated];
    
}
-(void)back
{
    [self popViewControllerAnimated:YES];
}
-(void)more
{
    FDActionSheet * as = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回首页", nil];
    [as setButtonTitleColor:QKColor(48, 206, 39) bgColor:nil fontSize:0 atIndex:0];
    [as setCancelButtonTitleColor:[UIColor whiteColor] bgColor:QKColor(48, 206, 39) fontSize:0];
    [as show];
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self popToRootViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
    
}

@end
