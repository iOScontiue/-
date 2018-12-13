//
//  CustomNavitionView.h
//  Bailingshengxue
//
//  Created by 卢育彪 on 2018/9/5.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CusLeftBtnBlock)(void);
typedef void(^CusRightBtnBlock)(void);
@class NavView;
@interface CustomNavitionView : NSObject

+ (NavView *)createNavViewWithTitle:(NSString *)title leftBtnImg:(UIImage *)leftImg rightBtnImg:(UIImage *)rightBtnImg superView:(UIView *)superView CusLeftBtnBlock:(CusLeftBtnBlock)leftBtnlock CusRightBtnBlock:(CusRightBtnBlock)rightblock;

+ (NavView *)createNavViewWithTitle:(NSString *)title leftBtnImg:(UIImage *)leftImg rightBtnTitle:(NSString *)rightStr superView:(UIView *)superView CusLeftBtnBlock:(CusLeftBtnBlock)leftBtnlock CusRightBtnBlock:(CusRightBtnBlock)rightblock;

@end

typedef void(^LeftBtnBlock)(void);
typedef void(^RightBtnBlock)(void);
@interface NavView : UIView

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UIImage *leftImg;
@property (nonatomic, strong) UIImage *rightImg;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, copy) LeftBtnBlock leftBtnBlock;
@property (nonatomic, copy) RightBtnBlock rightBtnBlock;

- (void)handleLeftBtnBlock:(LeftBtnBlock)block;
- (void)handleRightBtnBlock:(RightBtnBlock)block;

@end
