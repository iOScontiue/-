//
//  CommitMaintainViewController.h
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/12.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScanSelectedImgViewController.h"

#import "EasyNavigation.h"
#import "LXFPhotoHelper.h"//图库
#import "AlertViewManager.h"
#import "CustomNavitionView.h"

#import "HDragItemListView.h"
#import "UIView+Ex.h"
#import "MaintainImgsTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommitMaintainViewController : UIViewController

@property (nonatomic, strong) NavView *nav;
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UITextView *describeContent;
@property (nonatomic, strong) HDragItemListView *itemList;
@property (nonatomic, strong) MaintainImgsTableView *maintainTableView;

@property (nonatomic, assign) CGFloat lastTextViewHeight;
@property (nonatomic, assign) NSInteger tapIndex;

@end

NS_ASSUME_NONNULL_END
