//
//  MBProgressHUD+YY.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "MBProgressHUD+YY.h"

@implementation MBProgressHUD (YY)

+ (void)show:(NSString *)text withIcon:(NSString *)icon toView:(UIView *_Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    // delay秒之后再消失
    if (delay <= 0){
        delay = 2.0;
    }
    [hud hideAnimated:YES afterDelay:delay];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (delay+0.5) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        }
    });
}

/**
 成功提示

 @param success 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (1.0)
 @param block 关闭回调
 */
+ (void)showSuccess:(NSString *)success toView:(UIView * _Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block{
    [MBProgressHUD show:success withIcon:@"success" toView:view timeDelay:delay finishBlock:block];
}



/**
 失败提示
 
 @param error 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (1.0)
 @param block 关闭回调
 */
+ (void)showError:(NSString *)error toView:(UIView *_Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block{
    
    [MBProgressHUD show:error withIcon:@"error" toView:view timeDelay:delay finishBlock:block];
}

/**
 等待提示

 @param text 提示内容
 @param view 显示到view (view不传则显示到window上)
 @return MB实例
 */
+ (MBProgressHUD *)showHudWaiting:(NSString *)text toView:(UIView *_Nullable)view{
    if(!view){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    
    hud.label.textColor = [UIColor whiteColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

/**
 关闭Hud

 @param animated 是否动画
 @param delay 延迟时间
 @param block 关闭回调
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay finishBlock:(void(^)(void))block{
    
    [self hideAnimated:YES afterDelay:delay];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (delay+0.5) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        }
    });
}

/**
 Toast提示
 
 @param text 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (如：1.0,如果delay小于等0则默认2.0)
 @param block 关闭回调
 */
+ (void)showToast:(NSString *)text toView:(UIView *_Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.label.textColor = [UIColor whiteColor];
    // delay秒之后再消失
    if (delay <= 0){
        delay = 2.0;
    }
    [hud hideAnimated:YES afterDelay:delay];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (delay+0.5) * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        }
    });
}
@end
