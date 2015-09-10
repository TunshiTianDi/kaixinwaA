//
//  QKPutinInvateCodeVC.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/19.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKPutinInvateCodeVC.h"
#import "QKHttpTool.h"
#import "QKBaseResult.h"
#import "QKAccount.h"
#import "QKAccountTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "QKGetHappyPeaTool.h"

@interface QKPutinInvateCodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation QKPutinInvateCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = QKGlobalBg;
}
- (IBAction)finishButton:(id)sender {
    NSDictionary * param = @{@"uid":[QKAccountTool readAccount].uid,@"code":self.textField.text};
    //填写邀请码
    [QKHttpTool post:@"http://101.200.173.163/qkhl_api/index.php/kxwapi/Requestcode/requested" params:param success:^(id responseObj) {
        DCLog(@"%@",responseObj);
        QKBaseResult * result = [QKBaseResult objectWithKeyValues:responseObj];
        
        if ([result.code isEqualToNumber:@(200)]) {
            [MBProgressHUD showSuccess:@"填写成功"];
            //发请获取豆数
            [QKGetHappyPeaTool getHappyPeaNum];
        }else{
            [MBProgressHUD showError:result.message];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"无法连接服务器"];
    }];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
