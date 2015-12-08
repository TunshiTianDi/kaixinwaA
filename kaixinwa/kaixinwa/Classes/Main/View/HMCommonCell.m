//
//  HMCommonCell.m

//
//  Created by apple on 14-7-21.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMCommonCell.h"
#import "HMBadgeView.h"
#import "QKCommonItemHeader.h"
#import "UMessage.h"



@interface HMCommonCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *rightArrow;
/**
 *  开关
 */
@property (strong, nonatomic) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (strong, nonatomic) UILabel *rightLabel;
/**
 *  提醒数字
 */
@property (strong, nonatomic) HMBadgeView *bageView;
/**
 * 打钩
 */
@property (strong, nonatomic) UIImageView * checkView;

/**
 * icon
 */
@property (strong, nonatomic)UIImageView * iconView;

/**
 * 任务按钮
 */
@property(strong,nonatomic)UIButton * taskButton;


@end

@implementation HMCommonCell

#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UISwitch *)rightSwitch
{
    if (_rightSwitch == nil) {
        self.rightSwitch = [[UISwitch alloc] init];
        
        [self.rightSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}
-(void)changeSwitch:(UISwitch *)switchView
{
    HMCommonSwitchItem * switchItem = (HMCommonSwitchItem *)_item;
    switchItem.on = switchView.on;
    
    
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (HMBadgeView *)bageView
{
    if (_bageView == nil) {
        self.bageView = [[HMBadgeView alloc] init];
    }
    return _bageView;
}

-(UIImageView *)checkView
{
    if (_checkView == nil) {
        self.checkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_checkmark"]];
    }
    return _checkView;
}

-(UIImageView *)iconView
{
    if (_iconView == nil) {
        self.iconView = [[UIImageView alloc]init];
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconView.clipsToBounds = YES;
    }
    return _iconView;
}
-(UIButton *)taskButton
{
    if (_taskButton == nil) {
        self.taskButton = [[UIButton alloc]init];
        self.taskButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.taskButton setTitle:@"未完成" forState:UIControlStateNormal];
        
        [self.taskButton setTitle:@"已完成" forState:UIControlStateSelected];
        [self.taskButton setBackgroundImage:[UIImage imageNamed:@"undone-without-letter"] forState:UIControlStateNormal];
        [self.taskButton setBackgroundImage:[UIImage imageNamed:@"done-without-letter"] forState:UIControlStateSelected];
    }
    return _taskButton;
}

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    HMCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HMCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
       
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        
        self.detailView = [[UIImageView alloc]init];
        [self addSubview:self.detailView];
        
    }
    return self;
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.item isKindOfClass:[HMCommonAvatarItem class]]) {
        self.iconView.size = CGSizeMake(60, 60);
        self.iconView.x = self.width - self.iconView.width - 10;
        self.iconView.centerY = self.height * 0.5;
        self.iconView.layer.cornerRadius = self.iconView.width/2;
    }else if([self.item isKindOfClass:[QKCommonTaskButtonItem class]]){
        
        
        self.taskButton.width = 50;
        self.taskButton.height = 22;
        self.taskButton.x = self.width - self.taskButton.width - QKCellMargin;
        self.taskButton.centerY = self.height * 0.5;
        
        self.detailView.width = 42.5;
        self.detailView.height = 14;
        self.detailView.x = self.width - self.detailView.width - self.taskButton.width-QKCellMargin*2;
        self.detailView.centerY = self.height * 0.5;
        
    }
      // 调整子标题的x
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;

}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

- (void)setItem:(HMCommonItem *)item
{
    _item = item;
    
    // 1.设置基本数据
    self.imageView.image = item.icon;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    self.detailView.image = item.detailImage;
    
    // 2.设置右边的内容
    if (item.badgeValue) { // 紧急情况：右边有提醒数字
        self.bageView.badgeValue = item.badgeValue;
        self.accessoryView = self.bageView;
    } else if ([item isKindOfClass:[HMCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    } else if ([item isKindOfClass:[HMCommonSwitchItem class]]) {
        HMCommonSwitchItem * switchItem = (HMCommonSwitchItem *)item;
        self.rightSwitch.on = switchItem.on;
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[HMCommonLabelItem class]]) {
        HMCommonLabelItem *labelItem = (HMCommonLabelItem *)item;
        // 设置文字
        self.rightLabel.text = labelItem.text;
        // 根据文字计算尺寸
        self.rightLabel.size = [labelItem.text sizeWithAttributes:@{NSFontAttributeName:self.rightLabel.font}];
        self.accessoryView = self.rightLabel;
    }else if ([item isKindOfClass:[HMCommonCheckItem class]]){
        HMCommonCheckItem * checkItem = (HMCommonCheckItem *)item;
        if (checkItem.check) {
            self.accessoryView = self.checkView;
        }else {
            UILabel * label = [[UILabel alloc]init];
            label.text = @"未完成";
            label.font = [UIFont systemFontOfSize:11];
            label.size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
            self.accessoryView = label;
        }
    }else if ([item isKindOfClass:[QKCommonTaskButtonItem class]]){
        QKCommonTaskButtonItem * taskItem = (QKCommonTaskButtonItem *)item;
        self.taskButton.selected = taskItem.check;
        [self addSubview:self.taskButton];
        
    }else if ([item isKindOfClass:[HMCommonAvatarItem class]]) {
        
        HMCommonAvatarItem *avatarItem = (HMCommonAvatarItem *)item;
        self.iconView.image = avatarItem.avatar;
        
        [self addSubview:self.iconView];
    }else { // 取消右边的内容
        self.accessoryView = nil;
        [_iconView removeFromSuperview];
        _iconView = nil;
        [_taskButton removeFromSuperview];
        _taskButton = nil;
        [_detailView removeFromSuperview];
        _detailView = nil;
    }
}


@end
