//
//  UIViewController+Refresh.h
//  Project
//
//  Created by luowei on 2018/11/15.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define REFRESH_ALL_DATA @"REFRESH_ALL_DATA"

@interface UIViewController (Refresh)

//是否需要刷新
- (BOOL)isRefreshData;

//刷新回调
- (void)refereshDataHandle;

//调用平台刷新
- (void)refreshPlatformInfo;

@end

NS_ASSUME_NONNULL_END
