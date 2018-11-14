//
//  UIViewController+swizzling.h
//  UMa
//
//  Created by simple on 2018/5/30.
//  Copyright © 2018年 yanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

//全局执行刷新
#define REFRESH_ALL_DATA @"REFRESH_ALL_DATA"

@interface UIViewController (swizzling)


//是否显示导航为红色
- (BOOL)changeNavigationBarRedColor;

//是否需要刷新
- (BOOL)isRefreshData;

//刷新回调
- (void)refereshDataHandle;

//调用平台刷新
- (void)refreshPlatformInfo;

- (BOOL)isLightContentStatus;

- (BOOL)isHiddenNavigation;

@end
