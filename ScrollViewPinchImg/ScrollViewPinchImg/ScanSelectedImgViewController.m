//
//  ScanSelectedImgViewController.m
//  BoxHouseManaging
//
//  Created by 卢育彪 on 2018/12/11.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ScanSelectedImgViewController.h"

#import "EasyNavigation.h"
#import "LXFPhotoHelper.h"//图库
#import "AlertViewManager.h"
#import "CustomNavitionView.h"

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

@interface ScanSelectedImgViewController ()<UIScrollViewDelegate>
{
    CGFloat offset;
}

@property (nonatomic, strong) NSMutableArray *subScrollViewArr;
@property (nonatomic, strong) NSMutableArray *imgViewArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NavView *nav;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinGesRec;
@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGFloat minScale;

@end

@implementation ScanSelectedImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialParams];
    [self cuLayoutSubViews];
    [self configNav];
}

- (void)configNav
{
    __weak typeof(self)weakSelf = self;
    self.nav = [CustomNavitionView createNavViewWithTitle:[NSString stringWithFormat:@"%ld/%ld", (long)(self.index+1), (long)self.itemArr.count] leftBtnImg:nil rightBtnTitle:@"Delete" superView:self.view CusLeftBtnBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } CusRightBtnBlock:^{
        //delete
        [weakSelf deleteObject];
    }];
    
    self.nav.backgroundColor = [UIColor grayColor];
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    [self.nav.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nav.leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [self.nav.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)deleteObject
{
    __weak typeof(self)weakself = self;
    [AlertViewManager popAlertViewWithTitle:@"确定要删除吗" cancel:@"取消" confirm:@"确定" message:nil preferredStyle:UIAlertControllerStyleAlert target:self cancelBlock:^{
        
    } confirmBlock:^{
        UIImageView *deleteImgView = weakself.imgViewArr[weakself.index];
        [deleteImgView removeFromSuperview];
        [weakself.imgViewArr removeObjectAtIndex:weakself.index];
        
        UIScrollView *deleteScrollView = weakself.subScrollViewArr[weakself.index];
        [deleteScrollView removeFromSuperview];
        [weakself.subScrollViewArr removeObjectAtIndex:weakself.index];
        
        [weakself.itemArr removeObjectAtIndex:weakself.index];
        
        [weakself reloadData];
    }];
}

- (void)reloadData
{
    BL_LoadNavHeight
    
    for (NSInteger i = self.index; i < self.itemArr.count; i++) {
        HDragItem *item = (HDragItem *)self.itemArr[i];
        UIScrollView *subScrollView = self.subScrollViewArr[i];
        subScrollView.frame = CGRectMake(i*ScreenWidth_N(), navViewH, ScreenWidth_N(), ScreenHeight_N()-navViewH);
        UIImageView *imgView = self.imgViewArr[i];
        imgView.image = item.image;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteImageRefresh" object:nil userInfo:@{@"deleteIndex":[NSNumber numberWithInteger:self.index]}];
    
    if (self.itemArr.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        
        if (self.index+1 > self.itemArr.count) {
            self.index = self.itemArr.count-1;
        }
        
        self.nav.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(self.index+1), (long)self.itemArr.count];
        
        [self adjustScrollViewOffset];
        
    }
}

- (void)initialParams
{
    self.subScrollViewArr = [NSMutableArray array];
    self.imgViewArr = [NSMutableArray array];
    
    self.lastScale = 1;
    self.minScale = 1;
    self.maxScale = 10;
    offset = 0.0;
}

- (void)cuLayoutSubViews
{
    BL_LoadNavHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), ScreenHeight_N())];
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    
    //删除最后一个“+”号按钮
    [self.itemArr removeLastObject];
    [self.itemArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(idx*ScreenWidth_N(), navViewH, ScreenWidth_N(), ScreenHeight_N()-navViewH)];
        subScrollView.backgroundColor = [UIColor blackColor];
        subScrollView.contentSize = CGSizeMake(ScreenWidth_N(), ScreenHeight_N()-navViewH);
        subScrollView.delegate = self;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.minimumZoomScale = self.minScale;
        subScrollView.maximumZoomScale = self.maxScale;
        [subScrollView setZoomScale:1.0];
        
        HDragItem *item = (HDragItem *)obj;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), ScreenHeight_N()-navViewH)];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = item.image;
        
        UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGesClick:)];
        //捏合手势
        [imgView addGestureRecognizer:pin];
        [subScrollView addSubview:imgView];
        [self.scrollView addSubview:subScrollView];
        
        [self.subScrollViewArr addObject:subScrollView];
        [self.imgViewArr addObject:imgView];
        
    }];
    
    [self adjustScrollViewOffset];
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navHidden)];
    //    [self.scrollView addGestureRecognizer:tap];
}

- (void)adjustScrollViewOffset
{
    BL_LoadNavHeight
    [self.scrollView setContentOffset:CGPointMake(self.index*ScreenWidth_N(), navViewH)];
    
    if (@available(iOS 11.0, *)){
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.itemArr.count*ScreenWidth_N(), 0);
}

#pragma mark -
#pragma mark - Click Methods

- (void)pinGesClick:(UIPinchGestureRecognizer *)pinGes
{
//    switch (pinGes.state) {
//        case UIGestureRecognizerStateBegan://scale began
//        case UIGestureRecognizerStateChanged://scale changed
//        {
//            CGFloat currentScale = [[self.scrollView.layer valueForKeyPath:@"transform.scale"] floatValue];
//            CGFloat newScale = pinGes.scale - self.lastScale + 1;
//
//            newScale = MIN(newScale, self.maxScale / currentScale);
//            newScale = MAX(newScale, self.minScale / currentScale);
//
//            self.scrollView.transform = CGAffineTransformScale(self.scrollView.transform, newScale, newScale);
//
//            for (int i = 0; i < self.imgViewArr.count; i++) {
//                UIImageView *subImgView = self.imgViewArr[i];
//                NSLog(@"subImgView----%d---%@", i, subImgView);
//            }
//
//            self.lastScale = pinGes.scale;
//
//
//        }
//            break;
//        case UIGestureRecognizerStateEnded://scale ended
//            self.lastScale = 1;
//            break;
//        default:
//            break;
//    }
    
    float newScale = [(UIScrollView*)pinGes.view.superview zoomScale];
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)pinGes.view.superview withCenter:[pinGes locationInView:pinGes.view]];
    [(UIScrollView*)pinGes.view.superview zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)navHidden
{
    self.nav.hidden = !self.nav.hidden;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView){
        
        self.index = (NSInteger)(scrollView.contentOffset.x/ScreenWidth_N());
        self.nav.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(self.index+1), (long)self.itemArr.count];
        
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                }
            }
        }
    }
}

//放回当前缩放图片
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

// 开始放大或者缩小
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"crollViewWillBeginZooming");
}

// 缩放结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    //scale 缩放的比例
    NSLog(@"scrollViewDidEndZooming %f",scale);
}

// 视图已经放大或缩小
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidZoom");
}

@end
