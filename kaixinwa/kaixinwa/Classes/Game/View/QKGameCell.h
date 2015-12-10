//
//  QKGameCell.h
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKGameFrame.h"

@interface QKGameCell : UITableViewCell
@property(nonatomic,strong)QKGameFrame * gameFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
