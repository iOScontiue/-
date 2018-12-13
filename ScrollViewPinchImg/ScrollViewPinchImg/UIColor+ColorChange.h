//
//  UIColor+ColorChange.h
//  GaoBaoZhen
//
//  Created by adminMac on 2018/2/8.
//  Copyright © 2018年 adminMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
