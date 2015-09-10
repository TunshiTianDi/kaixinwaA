//
//  QKMessageCell.m
//  kaixinwa
//
//  Created by 张思源 on 15/9/6.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKMessageCell.h"
#import "QKMessageView.h"

@interface QKMessageCell()
@property(nonatomic,weak)QKMessageView * messageView;
@end

@implementation QKMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sharecell";
    QKMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[QKMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = QKGlobalBg;
        QKMessageView * messageView = [[QKMessageView alloc]init];
        messageView.frame = self.bounds;
        messageView.y = QKCellMargin;
        messageView.height = 60;
        [self addSubview:messageView];
        self.messageView = messageView;
    }
    return self;
}

-(void)setMessageContent:(QKMessageContent *)messageContent
{
    _messageContent = messageContent;
    self.messageView.messageContent = messageContent;
}
@end
