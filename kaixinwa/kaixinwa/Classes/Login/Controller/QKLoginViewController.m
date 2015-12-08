//
//  QKLoginViewController.m
//  kaixinwa
//
//  Created by 郭庆宇 on 15/6/29.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKLoginViewController.h"
#import "QKRegistViewController.h"
#import "QKRetrievePasswordViewController.h"
#import "QKHttpTool.h"
#import "QKTabBarController.h"
#import "MBProgressHUD+MJ.h"
#import "QKReturnResult.h"
#import "MJExtension.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
#import "QKControllerTool.h"
#import "OpenUDID.h"
#import "QKCheckString.h"
#import "LJWKeyboardHandlerHeaders.h"

@interface QKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)login:(id)sender;
- (IBAction)forgivePasswordButton:(id)sender;
- (IBAction)registButton:(id)sender;
//@property (nonatomic,copy)NSString * loginTime;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation QKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录开心蛙";
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, QKScreenWidth, 1)];
    aView.backgroundColor = [UIColor lightGrayColor];
    self.userNameTF.inputAccessoryView = aView;
    self.passwordTF.inputAccessoryView = aView;
    [self registerLJWKeyboardHandler];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"closeLogin" highImageName:@"closeLogin" target:self action:@selector(toTab3)];
}

-(void)toTab3{
    
    if (self.index == 2) {
        [QKControllerTool chooseRootViewControllerWithIndex:self.index];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)login:(id)sender {
    //检测密码是否符合格式
    if (![QKCheckString checkPassword:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码格式不正确"];
        return;
    }
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"登录中..."];
    NSDictionary* params = [self getLoginParams];
    [QKHttpTool post:LoginInterface params:params success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        DCLog(@"%@",responseObj);
        QKReturnResult * results = [QKReturnResult objectWithKeyValues:responseObj];
        NSString * code = [results.code stringValue];
        
        if ([code isEqualToString:@"201"]) {
            //存储账号信息
            QKAccount * account = [[QKAccount alloc]init];
            account.upkey = results.data.upkey;
            account.phoneNum =  results.data.telephone;
            account.uid = results.data.uid;
            account.created_time = results.data.create_time;
            account.client_type = results.data.client_type;
            account.user_type = results.data.user_type;
            account.lasttime = results.data.lasttime;
            account.school = results.data.school;
            account.user_name = results.data.user_name;
            account.signature = results.data.signature;
            account.address = results.data.address;
            account.weixin = results.data.weixin;
            account.qq = results.data.qq;
            account.token = results.data.token;
            account.header = results.data.header;
            [QKAccountTool save:account];
            //登陆成功跳转
            [QKControllerTool chooseRootViewController];
            
        }else{
            [MBProgressHUD showError:results.message];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"无法连接服务器"];
        DCLog(@"%@",error);
    }];
}
-(NSDictionary *)getLoginParams
{
//    NSDate * loginDate = [NSDate date];
//    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"yyyy-MM-dd-HH-mm";
//    NSString * loginTime = [fmt stringFromDate:loginDate];
//    self.loginTime = loginTime;
    NSString * md5Password =[QKHttpTool md5HexDigest:self.passwordTF.text];
    NSString * equipment_id = [OpenUDID value];
    NSDictionary * params = @{@"telephone":self.userNameTF.text,@"password":md5Password,@"client_type":@3,@"equipment_id":equipment_id};
    return params;
}

/**忘记密码 */
- (IBAction)forgivePasswordButton:(id)sender {
    QKRetrievePasswordViewController * rpVc = [[QKRetrievePasswordViewController alloc]init];
    [self.navigationController pushViewController:rpVc animated:YES];
}

/**注册账号 */
- (IBAction)registButton:(id)sender {
    QKRegistViewController*registVc = [[QKRegistViewController alloc]init];
    [self.navigationController pushViewController:registVc animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
