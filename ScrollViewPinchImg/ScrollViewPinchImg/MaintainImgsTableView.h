//
//  MaintainImgsTableView.h
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintainTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintainImgsTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *modelArr;

@end

NS_ASSUME_NONNULL_END
