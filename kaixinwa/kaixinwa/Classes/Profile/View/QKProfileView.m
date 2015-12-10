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

@property(nonatomic,weak)UILabel * templeLabel;

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
        if (account) {
            NSString * header = [QKAccountTool readAccount].header;
            NSURL * header_url = [NSURL URLWithString:header];
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"upload_header.data"];
            NSData * data = [NSData dataWithContentsOfFile:fullPathToFile];
            if(data){
                UIImage * placeholderImage = [UIImage imageWithData:data];
                icon.image = placeholderImage;
                self.image = [QKBackgroudTool gaussianBlur:placeholderImage];
            }else{
                [icon sd_setImageWithURL:header_url placeholderImage:[UIImage imageNamed:@"change_avatar-1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    self.image = [QKBackgroudTool gaussianBlur:image];
                    
                    [data writeToFile:fullPathToFile atomically:YES];
                    
                }];
            }
        }else{
            icon.image = [UIImage imageNamed:@"change_avatar-1"];
        }
        
        
        [self addSubview:icon];
        self.icon = icon;
        //创建头像装饰
        UIImageView * iconCammra =[[UIImageView alloc]init];
        iconCammra.image = [UIImage imageNamed:@"change_avatar-camera"];
        self.iconCammra = iconCammra;
        [self addSubview:iconCammra];
        if (account) {
            //昵称
            UILabel * nameLabel = [[UILabel alloc]init];
            nameLabel.font = [UIFont systemFontOfSize:17];
            [nameLabel setTextColor:[UIColor blackColor]];
            if ([account.user_name isEqualToString:@""]||account.user_name == nil) {
                nameLabel.text = @"点击头像设置昵称";
            }else{
                nameLabel.text = account.user_name;
            }
            [self addSubview:nameLabel];
            self.nameLabel = nameLabel;
            
            //学校信息
            UILabel * schoolInfo = [[UILabel alloc]init];
            schoolInfo.font = [UIFont systemFontOfSize:14];
            [schoolInfo setTextColor:[UIColor blackColor]];
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
            [signature setTextColor:[UIColor blackColor]];
            if ([account.signature isEqualToString:@""]||account.signature == nil) {
                signature.text = @"未设置";
            }else{
                signature.text = account.signature;
            }
            [self addSubview:signature];
            self.signature = signature;
        }else{
            UILabel * templeLabel = [[UILabel alloc]init];
            templeLabel.font = [UIFont systemFontOfSize:17];
            templeLabel.text = @"登录/注册";
            [templeLabel setTextColor:QKColor(87, 87, 87)];
            [self addSubview:templeLabel];
            self.templeLabel = templeLabel;
        }
        
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
    self.schoolInfo.x = (self.width - self.schoolInfo.width)/2;
    
    
    self.schoolInfo.text = noti.userInfo[@"school"];
}

-(void)changeUserName:(NSNotification *)noti
{
    self.nameLabel.size = [noti.userInfo[@"user_name"] sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    self.nameLabel.x = (self.width - self.nameLabel.width)/2;
    self.nameLabel.text = noti.userInfo[@"user_name"];
}

-(void)changeSignature:(NSNotification *)noti
{
    self.signature.size = [noti.userInfo[@"signature"] sizeWithAttributes:@{NSFontAttributeName:self.signature.font}];
    self.signature.x = (self.width - self.signature.width)/2;
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
    self.icon.layer.cornerRadius = self.icon.frame.size.width / 2;
    self.icon.clipsToBounds = YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setProfileViewFrame:(QKProfileViewFrame *)profileViewFrame
{
    _profileViewFrame = profileViewFrame;
    
    self.icon.frame = profileViewFrame.iconFrame;
    
    self.iconBG.frame = profileViewFrame.iconBGFrame;
    
    self.iconCammra.frame = profileViewFrame.iconCameraFrame;
    
    self.nameLabel.frame = profileViewFrame.nameLabelFrame;
    
    self.signature.frame = profileViewFrame.signatureLabelFrame;
    
    self.schoolInfo.frame = profileViewFrame.schoolLabelFrame;
    
    self.templeLabel.frame = profileViewFrame.templeLabelFrame;
    
    self.frame = profileViewFrame.frame;
    
    
}

@end
