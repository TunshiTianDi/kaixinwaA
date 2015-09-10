//
//  QKMessageCell.h
//  kaixinwa
//
//  Created by 张思源 on 15/9/6.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKMessageContent.h"
@interface QKMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)QKMessageContent * messageContent;

@end
