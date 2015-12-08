//
//  QKTestPushViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/2.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKTestPushViewController.h"
#import "QKControllerTool.h"
@interface QKTestPushViewController ()

@end

@implementation QKTestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fanhui" highImageName:@"jiantousel" target:self action:@selector(back)];
}

-(void)back
{
    [QKControllerTool chooseRootViewControllerWithIndex:0];
}
@end
