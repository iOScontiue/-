//
//  MaintainImgsTableView.m
//  ScrollViewPinchImg
//
//  Created by 卢育彪 on 2018/12/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "MaintainImgsTableView.h"

#define CellIdentify NSStringFromClass([MaintainTableViewCell class])
#define TITLE_ARR @[@"所在位置", @"谁可以看", @"提醒谁看"]

@implementation MaintainImgsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.modelArr = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass:[MaintainTableViewCell class] forCellReuseIdentifier:CellIdentify];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self requestData];
    }
    return self;
}

- (void)requestData
{
    for (int i = 0; i < TITLE_ARR.count; i++) {
        MaintainImgModel *model = [MaintainImgModel new];
        model.cellName = TITLE_ARR[i];
        [self.modelArr addObject:model];
    }
    [self reloadData];
}

#pragma mark -
#pragma mark - UITableViewDelegate And UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintainImgModel *model = self.modelArr[indexPath.section];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaintainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    MaintainImgModel *model = self.modelArr[indexPath.row];
    [cell loadData:model IndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

@end
