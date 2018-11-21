//
//  MBProgressHUD+YY.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (YY)

/**
 成功提示
 
 @param success 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (1.0)
 @param block 关闭回调
 */
+ (void)showSuccess:(NSString *)success toView:(UIView * _Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block;



/**
 失败提示
 
 @param error 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (1.0)
 @param block 关闭回调
 */
+ (void)showError:(NSString *)error toView:(UIView *_Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block;


/**
 等待提示
 
 @param text 提示内容
 @param view 显示到view (view不传则显示到window上)
 @return MB实例
 */
+ (MBProgressHUD *)showHudWaiting:(NSString *)text toView:(UIView *_Nullable)view;

/**
 关闭Hud
 
 @param animated 是否动画
 @param delay 延迟时间
 @param block 关闭回调
 */
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay finishBlock:(void(^)(void))block;

/**
 Toast提示
 
 @param text 提示内容
 @param view 显示到view (view不传则显示到window上)
 @param delay 延迟几秒关闭 (如：1.0,如果delay小于等0则默认2.0)
 @param block 关闭回调
 */
+ (void)showToast:(NSString *)text toView:(UIView *_Nullable)view timeDelay:(CGFloat)delay finishBlock:(void(^)(void))block;

@end
