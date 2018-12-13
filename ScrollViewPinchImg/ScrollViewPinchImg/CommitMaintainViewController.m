//
//  CommitMaintainViewController.m
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/12.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "CommitMaintainViewController.h"
#import <UITextView+ZWPlaceHolder.h>

#define Cancel @"取消"

#define kDescribeContentLeft 20
#define kDescribeContentTop 30
#define kDescribeContentHeight 80
#define kDescribeContentFont 16

#define kSingleLineHeight 36
#define kMaxLines  6
#define kMaintainImgsTableViewTop 70
#define kMaintainImgsTableViewHeight 200
#define kItemListTop 10
#define kItemListLeft 10

@interface CommitMaintainViewController ()

@end

@implementation CommitMaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialParams];
    [self configNav];
    [self cusLayoutSubViews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteImageRefresh" object:nil];
}

- (void)initialParams
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delImgRefresh:) name:@"DeleteImageRefresh" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configNav
{
    self.nav = [CustomNavitionView createNavViewWithTitle:@"" leftBtnImg:nil rightBtnTitle:@"发表" superView:self.view CusLeftBtnBlock:^{
        
    } CusRightBtnBlock:^{
        NSLog(@"------发表------");
    }];
    [self.nav.rightBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)cusLayoutSubViews
{
    /*布局：
     1.baseView；
     2.textview；
     3.itemlist；
     4.tableview；
     */
    
    [self createBaseView];
    [self createTextView];
    [self createImgViewItems];
    [self createTableView];
}

- (void)createBaseView
{
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.nav.bottom, ScreenWidth_N(), ScreenHeight_N()-self.nav.bottom)];
//    self.baseScrollView.backgroundColor = [UIColor purpleColor];
    //"+10"是为了增加垂直滑动的效果
    self.baseScrollView.contentSize = CGSizeMake(ScreenWidth_N(), ScreenHeight_N()-self.nav.height+10);
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.baseScrollView];
}

- (void)createTextView
{
    self.describeContent = [[UITextView alloc] initWithFrame:CGRectMake(kDescribeContentLeft, kDescribeContentTop, ScreenWidth_N()-2*kDescribeContentLeft, kDescribeContentHeight)];
    self.describeContent.font = [UIFont systemFontOfSize:kDescribeContentFont];
    self.describeContent.placeholder = @"描述内容...";
//    self.describeContent.backgroundColor = [UIColor purpleColor];
    [self.baseScrollView addSubview:self.describeContent];
}

- (void)createImgViewItems
{
    HDragItem *item = [[HDragItem alloc] init];
    item.backgroundColor = [UIColor clearColor];
    item.image = [UIImage imageNamed:@"add_image"];
    item.isAdd = YES;
    
    // 创建标签列表
    HDragItemListView *itemList = [[HDragItemListView alloc] initWithFrame:CGRectMake(kItemListLeft, self.describeContent.bottom+kItemListTop, self.view.frame.size.width-2*kItemListLeft, 0)];
    self.itemList = itemList;
//    itemList.backgroundColor = [UIColor orangeColor];
    // 高度可以设置为0，会自动跟随标题计算
    // 设置排序时，缩放比例
    itemList.scaleItemInSort = 1.3;
    // 需要排序
    itemList.isSort = YES;
    itemList.isFitItemListH = YES;
    
    [itemList addItem:item];
    
    __weak typeof(self) weakSelf = self;
    
    [itemList setClickItemBlock:^(HDragItem *item) {
        if (item.isAdd) {
            NSLog(@"添加");
            [weakSelf addImage];
        } else {
            [weakSelf handleItemClikEvent:item];
        }
    }];
    
    /**
     * 移除tag 高度变化，得重设
     */
    itemList.deleteItemBlock = ^(HDragItem *item) {
        HDragItem *lastItem = [weakSelf.itemList.itemArray lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!lastItem.isAdd) {
                HDragItem *item = [[HDragItem alloc] init];
                item.backgroundColor = [UIColor clearColor];
                item.image = [UIImage imageNamed:@"add_image"];
                item.isAdd = YES;
                [weakSelf.itemList addItem:item];
            }
            [weakSelf updateHeaderViewHeight];
        });
    };
    
    [self.baseScrollView addSubview:itemList];
}

- (void)createTableView
{
    self.maintainTableView = [[MaintainImgsTableView alloc] initWithFrame:CGRectMake(0, self.itemList.bottom+kMaintainImgsTableViewTop, ScreenWidth_N(), kMaintainImgsTableViewHeight) style:UITableViewStyleGrouped];
//    self.maintainTableView.backgroundColor = [UIColor cyanColor];
    [self.baseScrollView addSubview:self.maintainTableView];
}

//更新头部高度
- (void)updateHeaderViewHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maintainTableView.y = self.itemList.bottom+kMaintainImgsTableViewTop;
        self.baseScrollView.contentSize = CGSizeMake(ScreenWidth_N(), self.maintainTableView.bottom);
    }];
}

- (void)handleItemClikEvent:(HDragItem *)item
{
    UIImageView *imgView = item;
    for (UIImageView *sub in self.itemList.itemArray) {
        if ([imgView.image isEqual:sub.image]) {
            self.tapIndex = [self.itemList.itemArray indexOfObject:sub];
            NSLog(@"----tap-----index-------%ld", (long)self.tapIndex);
            break;
        }
    }

    ScanSelectedImgViewController *vc = [[ScanSelectedImgViewController alloc] init];
    vc.index = self.tapIndex;
    vc.itemArr = self.itemList.itemArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addImage
{
    [AlertViewManager popSheetViewWithTitle:@"更换头像" message:nil target:self cancelStr:Cancel defaultTypeArr:@[@"从相册中选择", @"拍照"] sheetDefaultBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                [self getSourceWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                break;
            case 1:
            {
                [self getSourceWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)getSourceWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LXFPhotoHelper creatWithSourceType:sourceType config:nil] getSourceWithSelectImageBlock:^(id data) {
            
            if ([data isKindOfClass:[UIImage class]]) { // 图片
                UIImage *img = (UIImage *)data;
                [self addImg:img];
            } else {
                NSLog(@"所选内容非图片对象");
            }
        }];
    });
    
}

- (void)addImg:(UIImage *)selectedImg
{
    HDragItem *item = [[HDragItem alloc] init];
    item.image = selectedImg;
    [self.itemList addItem:item];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateHeaderViewHeight];
    });
}

#pragma mark -
#pragma mark - Noti Methods

- (void)delImgRefresh:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSInteger index = [dic[@"deleteIndex"] integerValue];
    /*说明：
     ScanSelectedImgViewController中的itemArr跟以下itemArray指向的是同一片内存（因为itemArr并没有开辟内存），因此itemArr删除一个item后，itemArray也应保持同步，但以下并没有同步，依然不变——原因：itemArray属于只读属性，点引用时直接copy了HDragItemListView中的items变量
     */
    [self.itemList deleteItem:self.itemList.itemArray[index]];
}

@end
