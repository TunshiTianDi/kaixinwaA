//
//  QKRegistViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKRegistViewController.h"
#import "JKCountDownButton.h"
#import "QKHttpTool.h"
#import "OpenUDID.h"
#import "QKReturnResult.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKCheckString.h"
#import "LJWKeyboardHandlerHeaders.h"
#import "QKWebViewController.h"

@interface QKRegistViewController ()
- (IBAction)finishButton:(UIButton *)sender;
//注册协议
- (IBAction)RegistrationAgreement:(UIButton *)sender;

- (IBAction)tap:(id)sender;
- (IBAction)sendiCode:(JKCountDownButton *)sender;
@property (weak, nonatomic) IBOutlet JKCountDownButton *countDownButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
//短信验证码
@property (weak, nonatomic) IBOutlet UITextField *identifierCodeTF;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (nonatomic,copy)NSString * creat_time;

@end

@implementation QKRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self registerLJWKeyboardHandler];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigation_back" highImageName:@"navigation_back" target:self action:@selector(backTo)];
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, QKScreenWidth, 1)];
    aView.backgroundColor = [UIColor lightGrayColor];
    self.phoneNum.inputAccessoryView = aView;
    self.identifierCodeTF.inputAccessoryView = aView;
    self.passwordTF.inputAccessoryView = aView;
    
    self.countDownButton.enabled = NO;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumTFchange:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)phoneNumTFchange:(NSNotification *)noti
{
    if ([QKCheckString checkMobile:self.phoneNum.text]&&[self.phoneNum isFirstResponder]) {
        self.countDownButton.enabled = YES;
    }else{
        self.countDownButton.enabled = NO;
    }
}

#pragma mark ClickEvent
- (IBAction)finishButton:(UIButton *)sender {
    //检测密码是否符合格式
    if (![QKCheckString checkPassword:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码格式不正确"];
        return;
    }
    
    [MBProgressHUD showMessage:@"提交中..."];
    NSDictionary * params = [self getRegistParams];
//    @"http://192.168.1.115/qkhl_api/index.php/kxwapi/User/regist"
    [QKHttpTool post:RegisteInterfaceNew params:params success:^(id responseObj) {
        DCLog(@"%@",responseObj);
        [MBProgressHUD hideHUD];
        QKReturnResult * results = [QKReturnResult objectWithKeyValues:responseObj];
        NSString * code = [results.code stringValue];
        if ([code isEqualToString:@"201"]) {
            //注册成功
            //显示注册成功信息
            [MBProgressHUD showSuccess:results.message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:results.message];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        DCLog(@"%@",error);
    }];
}

- (IBAction)RegistrationAgreement:(UIButton *)sender {
    QKWebViewController * webVc = [[QKWebViewController alloc]init];
    webVc.urlStr =  @"http://qkhl-api.com/statement/statement.html";
    [self.navigationController pushViewController:webVc animated:YES];
}

-(NSDictionary *)getRegistParams
{
//    NSString * upkey = [self.phoneNum.text stringByAppendingString:self.passwordTF.text];
    //md5加密
    NSString* md5Password = [QKHttpTool md5HexDigest:self.passwordTF.text];
//    NSDate * now = [NSDate date];
//    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"yyyy-MM-dd-HH-mm";
//    NSString* creat_time = [fmt stringFromDate:now];
//    self.creat_time = creat_time;
    NSDictionary * params = @{@"telephone":self.phoneNum.text,@"mobile_code":self.identifierCodeTF.text,@"password":md5Password,@"user_type":@1,@"equipment_id":[OpenUDID value],@"client_type":@3};
    
    return params;
}

- (IBAction)tap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击发送验证码
- (IBAction)sendiCode:(JKCountDownButton *)sender {
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    DCLog(@"%@",self.phoneNum.text);
    NSDictionary * params = @{@"post_code":MiYao, @"telephone":self.phoneNum.text};

    
    [QKHttpTool post:SendSMSInterfaceNew params:params success:^(id responseObj) {
        DCLog(@"成功---%@",responseObj);
    } failure:^(NSError *error) {
        DCLog(@"失败----%@",error);
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTF endEditing:YES];
    [self.phoneNum endEditing:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
