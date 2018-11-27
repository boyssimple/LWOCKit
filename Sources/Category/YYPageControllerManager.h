//
//  YYPageControllerManager.h
//  Project
//
//  Created by luowei on 2018/11/27.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYPageControllerManagerEntity : NSObject
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@interface YYPageControllerManager : NSObject<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, assign) NSInteger selectIndex;

- (void)addDataSourceManagerEntity:(YYPageControllerManagerEntity*)entity withTableView:(UIPageViewController*)pageViewController;

@property (nonatomic, strong) void (^viewControllerAfterViewControllerBlock)(UIViewController *vc ,NSInteger index);
@end
