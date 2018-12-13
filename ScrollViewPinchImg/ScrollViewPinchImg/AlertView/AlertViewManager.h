//
//  AlertViewManager.h
//  PDF To Image By Fuhail
//
//  Created by 卢育彪 on 2018/7/27.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);
typedef void(^ConfirmBlock)(void);
typedef void(^ConfirmParamBlock)(NSString *param);
typedef void(^ConfirmParamsBlock)(NSString *param1, NSString *param2);
typedef void(^SheetDefaultBlock)(NSInteger index);

@interface AlertViewManager : NSObject

/**
 * 弹出AlertView
 * @param title 标题
 * @param cancel 取消
 * @param confirm 确定
 * @param mess  消息
 * @param stytle 弹出样式
 * @param target 控制器
 * @param cancelBlock 取消回调
 * @param confirmBlock 确定回调
 */
+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmBlock)confirmBlock;

/**
 * 弹出AlertView——只有确定按钮
 * @param title 标题
 * @param cancel 取消
 * @param confirm 确定
 * @param mess  消息
 * @param stytle 弹出样式
 * @param target 控制器
 * @param confirmBlock 确定回调
 */
+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess preferredStyle:(UIAlertControllerStyle)stytle target:(id)target confirmBlock:(ConfirmBlock)confirmBlock;

/**
 * 弹出AlertView———只有一个输入框
 * @param title 标题
 * @param cancel 取消
 * @param confirm 确定
 * @param mess  消息
 * @param placeholder  输入框提示
 * @param stytle 弹出样式
 * @param target 控制器
 * @param cancelBlock 取消回调
 * @param confirmParamBlock 确定回调
 */
+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess placeholder:(NSString *)placeholder preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmParamBlock)confirmParamBlock;

/**
 * 弹出AlertView———有两个输入框
 * @param title 标题
 * @param cancel 取消
 * @param confirm 确定
 * @param mess  消息
 * @param placeholder1  输入框提示1
 * @param placeholder2  输入框提示2
 * @param stytle 弹出样式
 * @param target 控制器
 * @param cancelBlock 取消回调
 * @param confirmParamsBlock 确定回调
 */
+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess placeholder1:(NSString *)placeholder1 placeholder2:(NSString *)placeholder2 preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmParamsBlock)confirmParamsBlock;

/**
 * 弹出SheetView
 * @param title 标题
 * @param mess 提示消息
 * @param cancelStr 取消标题
 * @param defaultTypeArr 操作事件数组
 * @param block 操作回调
 */
+ (void)popSheetViewWithTitle:(NSString *)title message:(NSString *)mess target:(id)target cancelStr:(NSString *)cancelStr defaultTypeArr:(NSArray *)defaultTypeArr sheetDefaultBlock:(SheetDefaultBlock)block;

@end
