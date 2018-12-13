//
//  CustomNavitionView.m
//  Bailingshengxue
//
//  Created by 卢育彪 on 2018/9/5.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "CustomNavitionView.h"
#import "EasyNavigation.h"
#import "UIColor+ColorChange.h"

#define BL_LoadNavHeight \
CGFloat navViewH = 64;\
CGFloat kTabBarHeight = 49;\
if (@available(iOS 11.0, *)) {\
UIWindow *window = [[[UIApplication sharedApplication] delegate] window];\
if (window.safeAreaInsets.bottom > 0.0) {\
navViewH = 88;\
kTabBarHeight = 49+34;\
}\
}\

#define kBottomLineHeight 1
#define kTitleLabelWidht 150
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44
#define kTitleLabelFont 18
#define showPWBtnWH 20
#define kLongBtnLR 40
#define kLongBtnHeight 45
#define kLongBtnRadius 45/2
#define kLongBtnTLFont 20
#define kBackBtnLeft 10
#define kBackBtnWH 50
#define kRightBtnWH 50

@implementation CustomNavitionView

+ (NavView *)createNavViewWithTitle:(NSString *)title leftBtnImg:(UIImage *)leftImg rightBtnImg:(UIImage *)rightBtnImg superView:(UIView *)superView CusLeftBtnBlock:(CusLeftBtnBlock)leftBtnlock CusRightBtnBlock:(CusRightBtnBlock)rightblock
{
    if (title != nil) {
//        CGFloat navViewH = kNavHeight;
//        if (@available(iOS 11.0, *)) {
//            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//            if (window.safeAreaInsets.bottom > 0.0) {
//                navViewH = kNavHeight_X;
//            }
//        }
        BL_LoadNavHeight;
        NavView *baseView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), navViewH)];
        [baseView handleLeftBtnBlock:^{
            leftBtnlock();
        }];
        [baseView handleRightBtnBlock:^{
            rightblock();
        }];
        baseView.titleStr = title;
        baseView.leftImg = leftImg;
        baseView.rightImg = rightBtnImg;
        [superView addSubview:baseView];
        return baseView;
    }
    return nil;
}

+ (NavView *)createNavViewWithTitle:(NSString *)title leftBtnImg:(UIImage *)leftImg rightBtnTitle:(NSString *)rightStr superView:(UIView *)superView CusLeftBtnBlock:(CusLeftBtnBlock)leftBtnlock CusRightBtnBlock:(CusRightBtnBlock)rightblock
{
    if (title != nil) {
//        CGFloat navViewH = kNavHeight;
//        if (@available(iOS 11.0, *)) {
//            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//            if (window.safeAreaInsets.bottom > 0.0) {
//                navViewH = kNavHeight_X;
//            }
//        }
        BL_LoadNavHeight;
        NavView *baseView = [[NavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), navViewH)];
        [baseView handleLeftBtnBlock:^{
            leftBtnlock();
        }];
        [baseView handleRightBtnBlock:^{
            rightblock();
        }];
        baseView.titleStr = title;
        baseView.leftImg = leftImg;
        baseView.rightTitle = rightStr;
        [superView addSubview:baseView];
        return baseView;
    }
    return nil;
}

@end

@implementation NavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    if (_titleStr != titleStr) {
        _titleStr = titleStr;
    }
    self.titleLabel.text = _titleStr;
}

- (void)setLeftImg:(UIImage *)leftImg
{
    if (_leftImg != leftImg) {
        _leftImg = leftImg;
    }
    
    if (self.leftBtn != nil) {
        [self.leftBtn removeFromSuperview];
    }
    
//    if (_leftImg != nil) {
        [self addSubview:self.leftBtn];
//    }
}

- (void)setRightTitle:(NSString *)rightTitle
{
    if (_rightTitle != rightTitle) {
        _rightTitle = rightTitle;
    }
    
    if (self.rightBtn != nil) {
        [self.rightBtn removeFromSuperview];
    }
    
//    if (_rightTitle != nil) {
        [self addSubview:self.rightBtn];
//    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-kTitleLabelWidht)/2.0, kStatusBarHeight, kTitleLabelWidht, kNavBarHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFont];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333345"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kBackBtnLeft, kStatusBarHeight+(kNavBarHeight-kBackBtnWH)/2.0, kBackBtnWH, kBackBtnWH)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _leftBtn.tag = 400;//rithtBtn.tag = 401
        [_leftBtn setImage:self.leftImg forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.tag = 401;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#51545D"] forState:UIControlStateNormal];
        [_rightBtn setTitle:self.rightTitle forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn sizeToFit];
        _rightBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-kBackBtnLeft-CGRectGetWidth(_rightBtn.frame), kStatusBarHeight+(kNavBarHeight-kRightBtnWH)/2.0, CGRectGetWidth(_rightBtn.frame), kRightBtnWH);
    }
    return _rightBtn;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-kBottomLineHeight, CGRectGetWidth(self.frame), kBottomLineHeight)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
}

- (void)handleLeftBtnBlock:(LeftBtnBlock)block
{
    if (block) {
        _leftBtnBlock = block;
    }
}

- (void)handleRightBtnBlock:(RightBtnBlock)block
{
    if (block) {
        _rightBtnBlock = block;
    }
}

#pragma mark -
#pragma mark - Click Methods

- (void)backClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 400:
        {
            if (self.leftBtnBlock) {
                self.leftBtnBlock();
            }
        }
            break;
        case 401:
        {
            if (self.rightBtnBlock) {
                self.rightBtnBlock();
            }
        }
            break;
        default:
            break;
    }
}

@end
