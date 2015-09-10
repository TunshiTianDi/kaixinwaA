//
//  QKProfileView.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/2.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKProfileView.h"
#import "QKUserInfo.h"
#import "UIImageView+WebCache.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
#import "QKHttpTool.h"
#import "QKGetHappyPeaTool.h"
#import "QKBackgroudTool.h"


#define QKTopMargin 30
#define QKUIMargin 10

@interface QKProfileView()

@property (nonatomic , weak)UILabel * nameLabel;
@property(nonatomic , weak)UILabel * schoolInfo;
@property(nonatomic , weak)UILabel * signature;
@property (nonatomic , weak)UIImageView * iconBG;
@property (nonatomic , weak)UIImageView * iconCammra;
@end

@implementation QKProfileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        //头像背景视图
        UIImageView * iconBG = [[UIImageView alloc]init];
        iconBG.image = [UIImage imageNamed:@"change_avatar-camera2"];
        [self addSubview:iconBG];
        self.iconBG = iconBG;
        
        //头像视图
        UIImageView * icon = [[UIImageView alloc]init];
        
        icon.userInteractionEnabled = YES;
        icon.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [icon addGestureRecognizer:tap];
        QKAccount * account = [QKAccountTool readAccount];
        NSString * fileName = [QKHttpTool md5HexDigest:account.phoneNum];
        fileName = [fileName stringByAppendingPathExtension:@"png"];
        //从沙盒中获取头像路径
        NSString * iconPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        iconPath = [iconPath stringByAppendingPathComponent:fileName];
//        DCLog(@"%@",iconPath);
        
        if([[QKUserDefaults objectForKey:@"upload"] isEqualToString:@"hadUpload"]){
            icon.image = [UIImage imageWithContentsOfFile:iconPath];
            //设置背景
            self.image = [QKBackgroudTool gaussianBlur:icon.image];
            
        }else{
            icon.image = [UIImage imageNamed:@"change_avatar-1"];
            
            NSURL * iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://kaixinwaavatar.oss-cn-beijing.aliyuncs.com/%@",fileName]];
            //下载头像
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data =[NSData dataWithContentsOfURL:iconURL];
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        icon.image = [UIImage imageWithData:data];
                        //设置背景
                        self.image = [QKBackgroudTool gaussianBlur:icon.image];
                        if (![[QKUserDefaults objectForKey:@"upload"] isEqualToString:@"hadUpload"]) {
                            //储存头像到本地
                            NSString * iconPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                            iconPath = [iconPath stringByAppendingPathComponent:fileName];
                            [data writeToFile:iconPath atomically:YES];
                            [QKUserDefaults setObject:@"hadUpload" forKey:@"upload"];
                            [QKUserDefaults synchronize];

                        }
                    }else{
                        icon.image = [UIImage imageNamed:@"change_avatar-1"];
                    }
                });
            });
        }
        [self addSubview:icon];
        self.icon = icon;
        //创建头像装饰
        UIImageView * iconCammra =[[UIImageView alloc]init];
        iconCammra.image = [UIImage imageNamed:@"change_avatar-camera"];
        self.iconCammra = iconCammra;
        [self addSubview:iconCammra];
        
        //昵称
        UILabel * nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont systemFontOfSize:17];
        [nameLabel setTextColor:[UIColor blackColor]];
        if ([account.user_name isEqualToString:@""]||account.user_name == nil) {
            nameLabel.text = @"未设置";
        }else{
            nameLabel.text = account.user_name;
        }
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //学校信息
        UILabel * schoolInfo = [[UILabel alloc]init];
        schoolInfo.font = [UIFont systemFontOfSize:14];
        [schoolInfo setTextColor:QKColor(87, 87, 87)];
        if ([account.school isEqualToString:@""]||account.school == nil) {
            schoolInfo.text = @"未设置";
        }else{
            schoolInfo.text = account.school;
        }
        [self addSubview:schoolInfo];
        self.schoolInfo = schoolInfo;
        
        //个性签名
        UILabel * signature = [[UILabel alloc]init];
        signature.font = [UIFont systemFontOfSize:14];
        [signature setTextColor:QKColor(87, 87, 87)];
        if ([account.signature isEqualToString:@""]||account.signature == nil) {
            signature.text = @"未设置";
        }else{
            signature.text = account.signature;
        }
        [self addSubview:signature];
        self.signature = signature;
        //注册通知改变头像
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIcon:) name:ChangeAvatarNote object:nil];
        //改变昵称
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserName:) name:ChangeUserName object:nil];
        //改变个性签名
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSignature:) name:ChangeSignature object:nil];
        //改变学校
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSchool:) name:ChangeSchool object:nil];
    }
    return self;
}

#pragma mark --- 通知方法
-(void)changeSchool:(NSNotification *)noti
{
    self.schoolInfo.size = [noti.userInfo[@"school"] sizeWithAttributes:@{NSFontAttributeName:self.schoolInfo.font}];
    self.schoolInfo.text = noti.userInfo[@"school"];
}

-(void)changeUserName:(NSNotification *)noti
{
    self.nameLabel.size = [noti.userInfo[@"user_name"] sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.nameLabel.text = noti.userInfo[@"user_name"];
}

-(void)changeSignature:(NSNotification *)noti
{
    self.signature.size = [noti.userInfo[@"signature"] sizeWithAttributes:@{NSFontAttributeName:self.signature.font}];
    self.signature.text = noti.userInfo[@"signature"];
}

-(void)changeIcon:(NSNotification *)note
{
    self.icon.image = note.userInfo[ChangAvatarKey];
    self.image = [QKBackgroudTool gaussianBlur:self.icon.image];
}

#pragma mark 代理方法
-(void)tapImage:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(tapProfileImage:)]) {
        [self.delegate tapProfileImage:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    self.icon.centerX  = self.centerX;
    self.icon.y = QKUIMargin;
    self.icon.height = 80;
    self.icon.width = 80;
    self.icon.layer.cornerRadius = self.icon.frame.size.width / 2;
    self.icon.clipsToBounds = YES;
    //    self.icon.layer.borderWidth = 3.0f;
    //    self.icon.layer.borderColor = [UIColor greenColor].CGColor;
    //头像背景
    self.iconBG.centerX = self.centerX;
    self.iconBG.centerY = self.icon.centerY;
    self.iconBG.height = 85;
    self.iconBG.width = 85;
    //头像右下角图标
    self.iconCammra.width = 20;
    self.iconCammra.height = 20;
    self.iconCammra.x = self.iconBG.x + self.iconBG.width-self.iconCammra.width-QKCellMargin*0.5;
    self.iconCammra.y = self.iconBG.y + self.iconBG.height - self.iconCammra.height-QKCellMargin*0.4;
    //昵称
    self.nameLabel.centerX = self.centerX;
    self.nameLabel.y = self.icon.height +2* QKUIMargin;
    self.nameLabel.size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    //个性签名
    self.signature.centerX = self.centerX;
    self.signature.y = self.nameLabel.y + self.nameLabel.height + QKUIMargin/2;
    self.signature.size = [self.signature.text sizeWithAttributes:@{NSFontAttributeName:self.signature.font}];
    //学校信息
    self.schoolInfo.centerX = self.centerX;
    self.schoolInfo.y = self.signature.y + self.signature.height + QKUIMargin/2;
    self.schoolInfo.size = [self.schoolInfo.text sizeWithAttributes:@{NSFontAttributeName:self.schoolInfo.font}];
    
    //自身尺寸
    self.height = self.schoolInfo.y + self.schoolInfo.height +QKUIMargin;
    self.width = [UIScreen mainScreen].bounds.size.width;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
