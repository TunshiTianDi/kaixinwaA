//
//  QKNewDiscoverController.m
//  kaixinwa
//
//  Created by 张思源 on 15/11/24.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKNewDiscoverController.h"
#import "QKCommonItemHeader.h"

@interface QKNewDiscoverController ()

@end

@implementation QKNewDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.bounces = NO;
    [self setupGroups];
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
    
    HMCommonArrowItem * radio = [HMCommonArrowItem itemWithTitle:@"开心电台" icon:[UIImage imageNamed:@"kaixindiantai"]];
    
    HMCommonArrowItem * video = [HMCommonArrowItem itemWithTitle:@"开心蛙动画" icon:[UIImage imageNamed:@"kaixinwadonghua"]];
    
    group.items = @[radio,video];
    
}

-(void)setupGroup1
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    HMCommonArrowItem * game = [HMCommonArrowItem itemWithTitle:@"开心游戏" icon:[UIImage imageNamed:@"kaixinyouxi"]];
    HMCommonArrowItem * exchange = [HMCommonArrowItem itemWithTitle:@"开心蛙兑换" icon:[UIImage imageNamed:@"kaixinwaduihuan"]];
    group.items = @[game,exchange];
}

@end
