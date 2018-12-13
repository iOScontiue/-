//
//  AlertViewManager.m
//  PDF To Image By Fuhail
//
//  Created by 卢育彪 on 2018/7/27.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "AlertViewManager.h"

@implementation AlertViewManager

+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmBlock)confirmBlock
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:stytle];
    [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmBlock();
    }]];
    [target presentViewController:ac animated:YES completion:nil];
}

+ (void)popSheetViewWithTitle:(NSString *)title message:(NSString *)mess target:(id)target cancelStr:(NSString *)cancelStr defaultTypeArr:(NSArray *)defaultTypeArr sheetDefaultBlock:(SheetDefaultBlock)block
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSInteger i = 0; i < defaultTypeArr.count; i++) {
        [ac addAction:[UIAlertAction actionWithTitle:defaultTypeArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }]];
    }
    [ac addAction:[UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:nil]];
    [target presentViewController:ac animated:YES completion:nil];
}

+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess preferredStyle:(UIAlertControllerStyle)stytle target:(id)target confirmBlock:(ConfirmBlock)confirmBlock
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:stytle];
    [ac addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmBlock();
    }]];
    [target presentViewController:ac animated:YES completion:nil];
}

+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess placeholder:(NSString *)placeholder preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmParamBlock)confirmParamBlock
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:stytle];
    [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = ac.textFields.firstObject;
        confirmParamBlock(textField.text);
    }]];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    [target presentViewController:ac animated:YES completion:nil];
}

+ (void)popAlertViewWithTitle:(NSString *)title cancel:(NSString *)cancel confirm:(NSString *)confirm message:(NSString *)mess placeholder1:(NSString *)placeholder1 placeholder2:(NSString *)placeholder2 preferredStyle:(UIAlertControllerStyle)stytle target:(id)target cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmParamsBlock)confirmParamsBlock
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:mess preferredStyle:stytle];
    [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField1 = ac.textFields.firstObject;
        UITextField *textField2 = ac.textFields.lastObject;
        confirmParamsBlock(textField1.text, textField2.text);
    }]];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder1;
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder2;
    }];
    [target presentViewController:ac animated:YES completion:nil];
}

@end
