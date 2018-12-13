//
//  MaintainTableViewCell.m
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "MaintainTableViewCell.h"

#define kLabelLeft 20
#define kLabelTop 20

#define kLineLeft 20
#define kLineHeight 1

@implementation MaintainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.firstTopLine];
        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIView *)firstTopLine
{
    if (!_firstTopLine) {
        _firstTopLine = [[UIView alloc] initWithFrame:CGRectMake(kLineLeft, 0, ScreenWidth_N()-2*kLineLeft, kLineHeight)];
        _firstTopLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _firstTopLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

- (void)loadData:(MaintainImgModel *)model IndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.firstTopLine.hidden = NO;
    } else {
        self.firstTopLine.hidden = YES;
    }
    
    self.nameLabel.text = model.cellName;
    [self.nameLabel sizeToFit];
    self.nameLabel.x = kLabelLeft;
    self.nameLabel.y = kLabelTop;
    
    CGFloat cellHeight = self.nameLabel.bottom+kLabelTop;
    self.bottomLine.frame = CGRectMake(kLineLeft, cellHeight-kLineHeight, ScreenWidth_N()-2*kLineLeft, kLineHeight);
    
    model.cellHeight = cellHeight;
}

@end
