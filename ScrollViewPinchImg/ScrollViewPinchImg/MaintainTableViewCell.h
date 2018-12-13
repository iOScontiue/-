//
//  MaintainTableViewCell.h
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintainImgModel.h"
#import "EasyNavigation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *firstTopLine;
@property (nonatomic, strong) UIView *bottomLine;

- (void)loadData:(MaintainImgModel *)model IndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
