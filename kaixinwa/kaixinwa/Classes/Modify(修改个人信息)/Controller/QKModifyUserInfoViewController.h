//
//  QKModifyUserInfoViewController.h
//  kaixinwa
//
//  Created by 张思源 on 15/7/3.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "HMCommonViewController.h"


typedef enum {
    QKUpdateUserName,
    QKUpdateSignature,
    QKUpdateSchool,
    QkUpdateQQ,
    QKUpdateWeChat
}QKUpdateType;

@interface QKModifyUserInfoViewController : HMCommonViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIImage * avatarImage;
@end
