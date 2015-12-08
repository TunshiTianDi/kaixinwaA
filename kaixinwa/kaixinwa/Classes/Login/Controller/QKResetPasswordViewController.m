//
//  QKResetPasswordViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKResetPasswordViewController.h"
#import "QKResetParam.h"
#import "MBProgressHUD+MJ.h"
#import "QKHttpTool.h"
#import "QKReturnResult.h"
#import "MJExtension.h"
#import "QKCheckString.h"


@interface QKResetPasswordViewController ()
- (IBAction)finishMod:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTF;

@end

@implementation QKResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigation_back" highImageName:@"navigation_back" target:self action:@selector(backTo)];
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, QKScreenWidth, 1)];
    aView.backgroundColor = [UIColor lightGrayColor];
    self.passwordTF.inputAccessoryView = aView;
    self.rePasswordTF.inputAccessoryView = aView;
}
-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishMod:(UIButton *)sender {
    //检测密码是否符合格式
    if (![QKCheckString checkPassword:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码格式不正确"];
        return;
    }
    
    if ([self.passwordTF.text isEqualToString:self.rePasswordTF.text]) {
        [MBProgressHUD showMessage:@"提交中"];
        NSString * md5Password = [QKHttpTool md5HexDigest:self.passwordTF.text];
        NSDictionary * params = @{@"password":md5Password,@"uid":self.resetParam.uid,@"telephone":self.resetParam.telephone};
        [QKHttpTool post:@"http://101.200.173.111/kaixinwa2.0/kxwaapi.php/User/modpwd" params:params success:^(id responseObj) {
            DCLog(@"-------%@",responseObj);
            QKReturnResult * result = [QKReturnResult objectWithKeyValues:responseObj];
            NSString* code = [result.code stringValue];
            [MBProgressHUD hideHUD];
            if ([code isEqualToString:@"201"]) {
                [MBProgressHUD showSuccess:result.message];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:result.message];
            }
            
        } failure:^(NSError *error) {
            DCLog(@"-------%@",error);
            [MBProgressHUD hideHUD];
        }];
        
    }else{
        [MBProgressHUD showError:@"密码不一致"];
    }
}
- (IBAction)tapLabel:(UITapGestureRecognizer *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTF endEditing:YES];
    [self.rePasswordTF endEditing:YES];
}

@end
