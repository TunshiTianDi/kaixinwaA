//
//  QKInvateFriendsViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/19.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKInvateFriendsViewController.h"
#import "QKHttpTool.h"
#import "QKInvateResult.h"
#import "MJExtension.h"
#import "QKAccountTool.h"
#import "QKAccount.h"
@interface QKInvateFriendsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *invateCode;

@end

@implementation QKInvateFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = QKGlobalBg;
    self.invateCode.text = [QKUserDefaults objectForKey:@"invateCode"];
    if (self.invateCode.text == nil) {
        NSDictionary * param = @{@"uid":[QKAccountTool readAccount].uid};
        [QKHttpTool post:@"http://101.200.173.163/qkhl_api/index.php/kxwapi/Requestcode/getcode" params:param success:^(id responseObj) {
            DCLog(@"%@",responseObj);
            QKInvateResult * result = [QKInvateResult objectWithKeyValues:responseObj];
            self.invateCode.text = result.data.code;
            [QKUserDefaults setObject:result.data.code forKey:@"invateCode"];
            [QKUserDefaults synchronize];
            
        } failure:^(NSError *error) {
            
        }];
    }
}


@end
