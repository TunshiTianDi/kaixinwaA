//
//  QKShareCell.m
//  kaixinwa
//
//  Created by 张思源 on 15/8/21.
//  Copyright (c) 2015年 乾坤翰林. All rights reserved.
//

#import "QKShareCell.h"
#import "QKShareDetailView.h"

@interface QKShareCell()
@property(nonatomic,weak)UILabel * dateLabel;
@property(nonatomic,weak)QKShareDetailView * shareDetailView;

@end

@implementation QKShareCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"sharecell";
    QKShareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[QKShareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel * dateLabel = [[UILabel alloc]init];
        dateLabel.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:dateLabel];
        self.dateLabel = dateLabel;
        QKShareDetailView * detailView = [[QKShareDetailView alloc]init];
        [self addSubview:detailView];
        self.shareDetailView = detailView;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.dateLabel.x = QKCellMargin;
    self.dateLabel.size = [self.dateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.dateLabel.font}];
    self.dateLabel.y = (self.height - self.dateLabel.height)/2;
    
    self.shareDetailView.x = CGRectGetMaxX(self.dateLabel.frame) + QKCellMargin * 2;
    self.shareDetailView.height = 54;
    self.shareDetailView.width = self.width - self.shareDetailView.x;
    self.shareDetailView.y = (self.height - self.shareDetailView.height)/2;
}
-(void)setMyShare:(QKMyShareObj *)myShare
{
    _myShare = myShare;
    self.dateLabel.text = myShare.shareTime;
    self.shareDetailView.myShare = myShare;
    
}

@end
