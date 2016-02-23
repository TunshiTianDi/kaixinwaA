//
//  QKRetrievePasswordViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKRetrievePasswordViewController.h"
#import "JKCountDownButton.h"
#import "QKResetPasswordViewController.h"
#import "QKReturnResult.h"
#import "QKHttpTool.h"
#import "MJExtension.h"
#import "QKResetParam.h"
#import "MBProgressHUD+MJ.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "QKCheckString.h"
#import "LJWKeyboardHandlerHeaders.h"

@interface QKRetrievePasswordViewController ()
- (IBAction)onClick:(JKCountDownButton *)sender;
- (IBAction)nextButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet JKCountDownButton *countDownButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCodeTF;

@end

@implementation QKRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigation_back" highImageName:@"navigation_back" target:self action:@selector(backTo)];
    [self registerLJWKeyboardHandler];
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, QKScreenWidth, 1)];
    aView.backgroundColor = [UIColor lightGrayColor];
    self.phoneNumTF.inputAccessoryView = aView;
    self.identifyingCodeTF.inputAccessoryView = aView;
    //注册输入框通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumTFchange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)phoneNumTFchange:(NSNotification *)noti
{
    if ([QKCheckString checkMobile:self.phoneNumTF.text]&&[self.phoneNumTF isFirstResponder]) {
        self.countDownButton.enabled = YES;
    }else{
        self.countDownButton.enabled = NO;
    }
}

- (IBAction)onClick:(JKCountDownButton *)sender {
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
    //发送请求获取短信验证码
    
    NSDictionary * params = @{@"post_code":MiYao, @"telephone":self.phoneNumTF.text};
    [QKHttpTool post:SendSMSInterfaceNew params:params success:^(id responseObj) {
        DCLog(@"成功---%@",responseObj);
    } failure:^(NSError *error) {
        DCLog(@"失败----%@",error);
    }];
    
}

- (IBAction)nextButton:(UIButton *)sender {
    [MBProgressHUD showMessage:@"验证中..."];
    //发送请求获取uid
    NSDictionary * params = @{@"telephone":self.phoneNumTF.text,@"mobile_code":self.identifyingCodeTF.text};
    [QKHttpTool post:codeVerityInterface params:params success:^(id responseObj) {
        DCLog(@"成功---%@",responseObj);
        [MBProgressHUD hideHUD];
        QKReturnResult * result = [QKReturnResult objectWithKeyValues:responseObj];
        NSString * code = [result.code stringValue];
        if ([code isEqualToString:@"201"]) {
//#warning 测试代码存储账号信息
//            QKAccount * account = [[QKAccount alloc]init];
//            account.upkey = result.data.upkey;
//            account.phoneNum =  result.data.telephone;
//            account.uid = result.data.uid;
//            account.created_time = result.data.create_time;
//            account.client_type = result.data.client_type;
//             account.user_type = result.data.user_type;
//            [QKAccountTool save:account];
//           ------------******-----------
            [MBProgressHUD showSuccess:result.message];
            QKResetPasswordViewController * resetVc = [[QKResetPasswordViewController alloc]init];
            QKResetParam * resetParam = [[QKResetParam alloc]init];
            resetParam.uid = result.data.uid;
            resetParam.telephone = result.data.telephone;
            resetVc.resetParam = resetParam;
            [self.navigationController pushViewController:resetVc animated:YES];
        }else{
            [MBProgressHUD showError:result.message];
        }
    } failure:^(NSError *error) {
        DCLog(@"失败---%@",error);
        [MBProgressHUD hideHUD];
    }];
}
- (IBAction)tapLabel:(UITapGestureRecognizer *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumTF endEditing:YES];
    [self.identifyingCodeTF endEditing:YES];
}
@end
