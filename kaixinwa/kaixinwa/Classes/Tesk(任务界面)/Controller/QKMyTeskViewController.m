//
//  QKMyTeskViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKMyTeskViewController.h"
#import "QKCommonItemHeader.h"
#import "MBProgressHUD+MJ.h"
#import "QKModifyUserInfoViewController.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
#import "QKHttpTool.h"
#import "MJExtension.h"
#import "QKSignResult.h"
#import "SDWebImageManager.h"
#import "QKGetHappyPeaTool.h"
#import "QKShareAppViewController.h"

@interface QKMyTeskViewController ()
@property(nonatomic,strong)QKCommonTaskButtonItem * uploadAvatar;

@end

@implementation QKMyTeskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroups];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.tableView.sectionFooterHeight = 0;
    
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
    
    group.header = @"每日任务";
    __weak typeof(self) wSelf = self;
    QKCommonTaskButtonItem * sign = [QKCommonTaskButtonItem itemWithTitle:@"每日签到"];
//    判断是否为今天且是否签到
    QKAccount* account = [QKAccountTool readAccount];
    NSDate * now = [NSDate date];
    NSTimeInterval nowTime =[now timeIntervalSince1970];
//    DCLog(@"条件now:%f,last:%f",nowTime,[account.lasttime doubleValue]);
    if (nowTime <= [account.lasttime doubleValue]){
        sign.check = YES;
    }else{
        sign.check = NO;
    }
    __weak typeof(sign) wSigh = sign;
    
    if (sign.check) {
        
        sign.detailImage = [UIImage imageNamed:@"plus-five-beans-yellow"];
    }else{
        sign.detailImage = [UIImage imageNamed:@"plus-five-beans-grey"];
    }
    sign.operation = ^{
        [wSelf signItem:wSigh];
    };
    
    QKCommonTaskButtonItem * share = [QKCommonTaskButtonItem itemWithTitle:@"分享开心蛙"];
    if(share.check){
        share.detailImage = [UIImage imageNamed:@"plus-ten-beans-yellow"];
        
    }else{
        share.detailImage = [UIImage imageNamed:@"plus-ten-beans-grey"];
        
    }
    share.destVcClass = [QKShareAppViewController class];
    
    
    QKCommonTaskButtonItem * invite = [QKCommonTaskButtonItem itemWithTitle:@"邀请好友"];
    if (invite.check) {
        invite.detailImage = [UIImage imageNamed:@"plus-fifteen-beans-yellow"];
    }else{
        invite.detailImage = [UIImage imageNamed:@"plus-fifteen-beans-grey"];
    }
    group.items = @[sign,share,invite];
}

//签到方法
-(void)signItem:(QKCommonTaskButtonItem *)item
{
    QKAccount * account = [QKAccountTool readAccount];
    if (account.lasttime) {
        
        //发送签到请求
        NSDictionary * param = @{@"uid":account.uid};
        [QKHttpTool post:SignEverydayInterface params:param success:^(id responseObj) {
//            DCLog(@"----%@",responseObj);
            QKSignResult * signResult =[QKSignResult objectWithKeyValues:responseObj];
            NSString * code = [signResult.code stringValue];
            //更新账号信息
            if ([code isEqualToString:@"201"]) {
                item.check = YES;
                item.detailImage = [UIImage imageNamed:@"plus-five-beans-yellow"];
                account.lasttime = signResult.data.lasttime;
                [QKAccountTool save:account];
                [MBProgressHUD showSuccess:signResult.message];
                [QKGetHappyPeaTool getHappyPeaNum];
                //发送通知完成签到任务
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishSignTask" object:nil];
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showError:signResult.message];
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            DCLog(@"----%@",error);
        }];
    }else{
        [MBProgressHUD showError:@"已签到"];
    };
    
}

-(void)setupGroup1
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    QKAccount * account = [QKAccountTool readAccount];
    
    group.header = @"成长任务";
    QKCommonTaskButtonItem * regInfo = [QKCommonTaskButtonItem itemWithTitle:@"注册信息"];
    if (account) {
        regInfo.check = YES;
    }
    if (regInfo.check) {
        regInfo.detailImage = [UIImage imageNamed:@"plus-five-beans-yellow"];
        regInfo.destVcClass = nil;
    }else{
        regInfo.detailImage = [UIImage imageNamed:@"plus-five-beans-grey"];
        regInfo.destVcClass = [QKModifyUserInfoViewController class];
        
    }
    QKCommonTaskButtonItem * schoolInfo = [QKCommonTaskButtonItem itemWithTitle:@"填写学校信息"];
    if (![account.school isEqualToString:@""]) {
        schoolInfo.check = YES;
    }
    if (schoolInfo.check) {
        schoolInfo.detailImage = [UIImage imageNamed:@"plus-ten-beans-yellow"];
        schoolInfo.destVcClass = nil;
    }else{
        schoolInfo.detailImage = [UIImage imageNamed:@"plus-ten-beans-grey"];
        schoolInfo.destVcClass = [QKModifyUserInfoViewController class];
    }
    
    QKCommonTaskButtonItem * uploadAvatar = [QKCommonTaskButtonItem itemWithTitle:@"上传头像"];
    //是否上传头像判断
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"upload"] isEqualToString:@"hadUpload"]) {
        uploadAvatar.check = YES;
    }
    
    if (uploadAvatar.check) {
        uploadAvatar.detailImage = [UIImage imageNamed:@"plus-ten-beans-yellow"];
        uploadAvatar.destVcClass = nil;
    }else{
        uploadAvatar.detailImage = [UIImage imageNamed:@"plus-ten-beans-grey"];
        uploadAvatar.destVcClass = [QKModifyUserInfoViewController class];
    }
    
    uploadAvatar.destVcClass = [QKModifyUserInfoViewController class];
    self.uploadAvatar = uploadAvatar;
    
    QKCommonTaskButtonItem * bondWeixin = [QKCommonTaskButtonItem itemWithTitle:@"绑定微信"];
    if (![account.weixin isEqualToString:@""]){
        bondWeixin.check = YES;
    }
    if (bondWeixin.check) {
        bondWeixin.detailImage = [UIImage imageNamed:@"plus-five-beans-yellow"];
        bondWeixin.destVcClass = nil;
    }else{
        bondWeixin.detailImage = [UIImage imageNamed:@"plus-five-beans-grey"];
        bondWeixin.destVcClass = [QKModifyUserInfoViewController class];
    }
    
    QKCommonTaskButtonItem * bondQQ = [QKCommonTaskButtonItem itemWithTitle:@"绑定QQ"];
    if (![account.qq isEqualToString:@""]){
        bondQQ.check = YES;
    }
    if (bondQQ.check) {
        bondQQ.detailImage = [UIImage imageNamed:@"plus-five-beans-yellow"];
        bondQQ.destVcClass = nil;
    }else{
        bondQQ.detailImage = [UIImage imageNamed:@"plus-five-beans-grey"];
        bondQQ.destVcClass = [QKModifyUserInfoViewController class];
    }
    
    group.items = @[regInfo,schoolInfo,uploadAvatar,bondWeixin,bondQQ];
}


@end
