//
//  QKModifyUserInfoViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/3.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKModifyUserInfoViewController.h"
#import "QKCommonItemHeader.h"
#import <ALBB_OSS_IOS_SDK/OSSService.h>
#import "FDActionSheet.h"
#import "QKHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "QKUpdateParam.h"
#import "MJExtension.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKReturnResult.h"
#import "QKPickerView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "QKAlertView.h"
#import "QKGetHappyPeaTool.h"


#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface QKModifyUserInfoViewController ()<QKAreaPickerDelegate,MBProgressHUDDelegate,FDActionSheetDelegate,QKAlertViewDelegate>

@property(nonatomic,copy)NSString * imageFileName;
@property(nonatomic,copy)NSString * imageDataPath;
@property(nonatomic,strong)HMCommonLabelItem * schoolInfo;
@property(nonatomic,strong)HMCommonLabelItem * address;
@property(nonatomic,strong)HMCommonAvatarItem * iconItem;
@property(nonatomic,strong)QKPickerView * pickerView;
@property(nonatomic,copy)NSString* areaValue;
@property(nonatomic,strong)UIView * maskView;
/** 自定义弹出视图*/
@property(nonatomic,strong)QKAlertView *alvCustom;

@end

@implementation QKModifyUserInfoViewController
{
    OSSBucket *bucket;
    OSSData *ossDownloadData;
    OSSData *ossUploadData;
    NSString *accessKey;
    NSString *secretKey;
    NSString *yourBucket;
    
    NSString *yourUploadObjectKey;
    NSString *yourUploadDataPath;
    NSString *yourHostId;
}

#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyMask)]];
}
-(void)hideMyMask
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        [self cancelLocatePicker];
        [self.alvCustom hide];
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性设置";
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self setupGroups];
    [self initView];
    //注册通知改变头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIcon:) name:ChangeAvatarNote object:nil];
}

-(void)changeIcon:(NSNotification *)note
{
    DCLog(@"通知--%s", __func__);
    self.iconItem.avatar = note.userInfo[ChangAvatarKey];
    [self.tableView reloadData];
}

-(void)setupGroups{
    [self setupGroup0];
    
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup1];
}
-(void)setupGroup0{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];

    HMCommonAvatarItem * iconItem = [HMCommonAvatarItem itemWithTitle:@"头像"];
    iconItem.avatar = self.avatarImage;
    iconItem.operation = ^{
        DCLog(@"点击可以更换头像");
        FDActionSheet * as = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍摄", @"从相册选取", nil];
        [as setButtonTitleColor:QKColor(48, 206, 39) bgColor:nil fontSize:0 atIndex:0];
        [as setButtonTitleColor:QKColor(48, 206, 39) bgColor:nil fontSize:0 atIndex:1];
        [as setCancelButtonTitleColor:[UIColor whiteColor] bgColor:QKColor(48, 206, 39) fontSize:0];
        [as show];
    };
    self.iconItem = iconItem;
        //添加各种cell
    group.items = @[iconItem];
    
}
-(void)setupGroup2
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    QKAccount * account = [QKAccountTool readAccount];
    //设置昵称cell
    HMCommonLabelItem * nickname = [HMCommonLabelItem itemWithTitle:@"昵称"];
    __weak typeof(HMCommonLabelItem) *weakNickname = nickname;
    nickname.text = [account.user_name isEqualToString:@""]? @"未设置" : account.user_name;
    //设置修改昵称的点击事件
    nickname.operation = ^{
        [self updateInfo:QKUpdateUserName andPlaceholder:@"设置昵称" andKeyboardType:UIKeyboardTypeDefault andUpdateType:@"user_name" andCellType:weakNickname];
    };
    //个性签名cell
    HMCommonLabelItem * signature = [HMCommonLabelItem itemWithTitle:@"个性签名"];
    signature.text = [account.signature isEqualToString:@""]? @"未设置" : account.signature;
    __weak typeof (HMCommonLabelItem) * weakSignature = signature;
    signature.operation = ^{
        //        [self updateUserInfoWithParamType:@"signature" andCellType:weakSignature andTitle:@"设置个性签名" andEnumType:QKUpdateSignature];
        [self updateInfo:QKUpdateSignature andPlaceholder:@"设置个性签名" andKeyboardType:UIKeyboardTypeDefault andUpdateType:@"signature" andCellType:weakSignature];
    };
    group.items = @[nickname,signature];
}
-(void)setupGroup3
{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    //获取头像url
    QKAccount * account = [QKAccountTool readAccount];
    //绑定微信cell
    HMCommonLabelItem * bondWeiXin = [HMCommonLabelItem itemWithTitle:@"绑定微信"];
    bondWeiXin.text = [account.weixin isEqualToString:@""]? @"未绑定" : account.weixin;
    __weak typeof (HMCommonLabelItem) * weakBondWeiXin = bondWeiXin;
    bondWeiXin.operation = ^{
        [self updateInfo:QKUpdateWeChat andPlaceholder:@"设置微信" andKeyboardType:UIKeyboardTypeNumberPad andUpdateType:@"weixin" andCellType:weakBondWeiXin];
    };
    //绑定QQ cell
    HMCommonLabelItem * bondQQ = [HMCommonLabelItem itemWithTitle:@"绑定QQ"];
    bondQQ.text = [account.qq isEqualToString:@""]? @"未绑定" : account.qq;
    __weak typeof (HMCommonLabelItem) * weakBondQQ = bondQQ;
    bondQQ.operation = ^{
        //        [self updateUserInfoWithParamType:@"qq" andCellType:weakBondQQ andTitle:@"设置qq号" andEnumType:QkUpdateQQ];
        [self updateInfo:QkUpdateQQ andPlaceholder:@"设置qq号" andKeyboardType:UIKeyboardTypeNumberPad andUpdateType:@"qq" andCellType:weakBondQQ];
    };
    //添加各种cell
    group.items = @[bondWeiXin,bondQQ];
}
#pragma mark - 自定义alertview的代理方法
//自定义ALV修改信息方法
-(void)updateInfo:(QKUpdateType)type andPlaceholder:(NSString *)placeholder andKeyboardType:(UIKeyboardType)keyboardType andUpdateType:(NSString*)updateType andCellType:(HMCommonLabelItem *)labelItem
{
    //添加遮盖
    [self.navigationController.view addSubview:self.maskView];
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha =  0.3;
    }];
    QKAlertView *alv = [[QKAlertView alloc]init];
    alv.delegate = self;
    alv.tag = type;
    alv.updateType = updateType;
    alv.textField.placeholder = placeholder;
    alv.textField.keyboardType = keyboardType;
    alv.item = labelItem;
    self.alvCustom = alv;
    [alv showInView:self.navigationController.view];
}

- (void)alertViewClickSubmitButton:(QKAlertView *)alertView
{
    QKAccount * account = [QKAccountTool readAccount];
    QKUpdateParam * param = [QKUpdateParam param];
    param.update_date = alertView.textField.text;
    param.update_type = alertView.updateType;
    NSDictionary * dic = [param keyValues];
    [QKHttpTool post:UpdataUserInfoInterface params:dic success:^(id responseObj) {
        QKReturnResult * results = [QKReturnResult objectWithKeyValues:responseObj];
        NSString * code = [results.code stringValue];
        if ([code isEqualToString:@"201"]) {
            switch (alertView.tag) {
                case QKUpdateUserName:
                    account.user_name = alertView.textField.text;
                    [QKAccountTool save:account];
                    //发送改变昵称的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserName object:nil userInfo:@{@"user_name":alertView.textField.text}];
                    break;
                case QKUpdateSignature:
                    account.signature = alertView.textField.text;
                    [QKAccountTool save:account];
                    //发送改变个性签名的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSignature object:nil userInfo:@{@"signature":alertView.textField.text}];
                    break;
                case QKUpdateSchool:
                    if ([account.school isEqualToString:@""]) {
                        [QKGetHappyPeaTool getHappyPeaWithUpdate:@"school"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishUpdateSchool" object:nil];
                    }
                    account.school = alertView.textField.text;
                    [QKAccountTool save:account];
                    //发送改变学校的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeSchool object:nil userInfo:@{@"school":alertView.textField.text}];
                    break;
                    //更新QQ信息
                case QkUpdateQQ:
                    if([account.qq isEqualToString:@""]){
                        //首次
                        [QKGetHappyPeaTool getHappyPeaWithUpdate:@"qq"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishBondQQ" object:nil];
                        
                    }
                    account.qq = alertView.textField.text;
                    [QKAccountTool save:account];
                    break;
                    //更新微信
                case QKUpdateWeChat:
                    if ([account.weixin isEqualToString:@""]) {
                        //首次填写获取开心豆
                        [QKGetHappyPeaTool getHappyPeaWithUpdate:@"weixin"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishBondWeChat" object:nil];
                    }
                    account.weixin = alertView.textField.text;
                    [QKAccountTool save:account];
                    break;
            }
            alertView.item.text = alertView.textField.text;
            [self.tableView reloadData];
            [MBProgressHUD showSuccess:results.message];
            [self hideMyMask];
        }else{
            [MBProgressHUD showError:results.message];
            [self hideMyMask];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        [self hideMyMask];
    }];

}



-(void)setupGroup1{
    HMCommonGroup * group = [HMCommonGroup group];
    [self.groups addObject:group];
    QKAccount* account = [QKAccountTool readAccount];
    //gps地址cell
    HMCommonLabelItem * address = [HMCommonLabelItem itemWithTitle:@"我的地址"];
    
    address.text = [account.address isEqualToString:@""]? @"点击设置地址" : account.address;
    self.address = address;
    
    __block __weak QKModifyUserInfoViewController * weakSelf = self;
    address.operation = ^{
        //添加遮盖
        [weakSelf.navigationController.view addSubview:weakSelf.maskView];
        weakSelf.maskView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.maskView.alpha =  0.3;
        }];
        [weakSelf cancelLocatePicker];
        //创建选择器
        QKPickerView * pickerView = [[QKPickerView alloc]initWithDelegate:weakSelf];
        [pickerView showInView:weakSelf.navigationController.view];
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", pickerView.locate.state, pickerView.locate.city, pickerView.locate.district];
        self.pickerView = pickerView;
    };
    
    //学校信息cell
    HMCommonLabelItem * schoolInfo = [HMCommonLabelItem itemWithTitle:@"学校信息"];
    
    schoolInfo.text = [account.school isEqualToString:@""] ? @"填写学校信息":account.school;
    self.schoolInfo = schoolInfo;
    __weak typeof(schoolInfo) weakSchoolInfo = schoolInfo;
    schoolInfo.operation = ^{
//        [weakSelf updateUserInfoWithParamType:@"school" andCellType:weakSchoolInfo andTitle:@"填写学校名称" andEnumType:QKUpdateSchool];
        [weakSelf updateInfo:QKUpdateSchool andPlaceholder:@"填写学校名称" andKeyboardType:UIKeyboardTypeDefault andUpdateType:@"school" andCellType:weakSchoolInfo];
    };
    group.items = @[address,schoolInfo];
}
#pragma mark - QKPickerView delegate
-(void)cancelLocatePicker
{
    [self.pickerView cancelPicker];
    self.pickerView.delegate = nil;
    self.pickerView = nil;
}
-(void)pickerDidChaneStatus:(QKPickerView *)picker
{
    self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
}
-(void)clickSubmit
{
    //发送请求 更改地址
    QKAccount * account = [QKAccountTool readAccount];
    QKUpdateParam * param = [QKUpdateParam param];
    param.update_date = self.areaValue;
    param.update_type = @"address";
    param.uid = account.uid;
    NSDictionary * paramDic = [param keyValues];
    [QKHttpTool post:UpdataUserInfoInterface params:paramDic success:^(id responseObj) {
        DCLog(@"%@",responseObj);
        QKReturnResult * results = [QKReturnResult objectWithKeyValues:responseObj];
        NSString * code = [results.code stringValue];
        if ([code isEqualToString:@"201"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            account.address = self.areaValue;
            [QKAccountTool save:account];
            self.address.text = self.areaValue;
            [self hideMyMask];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:results.message];
        }
        
    } failure:^(NSError *error) {
        DCLog(@"%@",error);
    }];
}

-(void)clickCancle
{
    [self hideMyMask];
}

#pragma mark 阿里云服务器初始化参数
//阿里云上传头像代码
-(void)setupOSSParams
{
    accessKey = ALBB_OSS_AccessKey;
    secretKey = ALBB_OSS_SecretKey;
    yourBucket = ALBB_OSS_Bucket;
    yourUploadObjectKey = self.imageFileName;
    yourUploadDataPath = self.imageDataPath;
    yourHostId = ALBB_OSS_HostID;
}
//初始化阿里云服务
- (void)initOSSService
{
    id<ALBBOSSServiceProtocol> ossService = [ALBBOSSServiceProvider getService];
    [ossService setGlobalDefaultBucketAcl:PRIVATE];
    [ossService setGlobalDefaultBucketHostId:yourHostId];
    [ossService setAuthenticationType:ORIGIN_AKSK];
    [ossService setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        NSLog(@"here signature:%@", signature);
        return signature;
    }];
    bucket = [ossService getBucket:yourBucket];
    
    ossUploadData = [ossService getOSSDataWithBucket:bucket key:yourUploadObjectKey];
    NSData *uploadData = [[NSData alloc] initWithContentsOfFile:yourUploadDataPath];
    [ossUploadData setData:uploadData withType:@"type"];
    [ossUploadData enableUploadCheckMd5sum:YES];
}


#pragma mark - 处理FDActionSheet的delegate

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    DCLog(@"%li",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openAlbum];
            break;
        default:
            break;
    }
    
}
/**
 *  打开照相机
 */
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        DCLog(@"不支持照相");
    }
}

/**
 *  打开相册
 */
- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 1.取出选中的图片
    UIImage * originalImage = info[UIImagePickerControllerEditedImage];
    UIImage * newImage = [self.iconItem addImage:originalImage];
    QKAccount * account = [QKAccountTool readAccount];
    NSString * newImageName = [QKHttpTool md5HexDigest:account.phoneNum];
    [self saveImage:newImage WithName:newImageName];
    
    //发个改变头像的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeAvatarNote object:nil userInfo:@{ChangAvatarKey : newImage}];
}
//处理照片本地化后上载
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    
    NSData * imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    if(imageData==nil){
        imageData = UIImagePNGRepresentation(tempImage);
    }
    imageName = [imageName stringByAppendingPathExtension:@"png"];
    
    self.imageFileName = imageName;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
    self.imageDataPath = fullPathToFile;
    
    //设置上传图片参数
    [self setupOSSParams];
    //初始化阿里云服务
    [self initOSSService];
    //开始上传
    [self uploadStart];
}

-(void)uploadStart
{
    [MBProgressHUD showMessage:@"正在上传"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ossUploadData uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                [MBProgressHUD showSuccess:@"头像上传成功"];
            } else {
                DCLog(@"失败原因：%@", error);
            }
        } withProgressCallback:^(float progress) {
            DCLog(@"当前进度： %f", progress);
            if (progress >= 1.00) {
                
                [MBProgressHUD hideHUD];
            }
        }];
    });
}

@end
