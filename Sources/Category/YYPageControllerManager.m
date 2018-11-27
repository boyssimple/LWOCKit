//
//  YYPageControllerManager.m
//  Project
//
//  Created by luowei on 2018/11/27.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYPageControllerManager.h"

@interface YYPageControllerManager()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation YYPageControllerManager

- (void)addDataSourceManagerEntity:(YYPageControllerManagerEntity*)entity withTableView:(UIPageViewController*)pageViewController{
    self.dataSource = entity.viewControllers;
    
    UIViewController *initialViewController = [self viewControllerAtIndex:entity.currentIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
    
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.dataSource count]) {
        return nil;
    }
    UIViewController *vc = [self viewControllerAtIndex:index];
    return vc;
    
    
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    return self.pageContentArray.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return 8;
//}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (finished) {
        UIViewController *vc = [pageViewController.viewControllers firstObject];
        if (self.viewControllerAfterViewControllerBlock) {
            NSInteger index = [self indexOfViewController:vc];
            self.viewControllerAfterViewControllerBlock(vc, index);
        }
    }
    
}

#pragma mark - 根据index得到对应的UIViewController

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.dataSource count] == 0) || (index >= [self.dataSource count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    
    NSString *str = [self.dataSource objectAtIndex:index];
    UIViewController *vc = [[NSClassFromString(str) alloc]init];
    vc.view.tag = 1000000+index;
    return vc;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return viewController.view.tag - 1000000;
}

@end

@implementation YYPageControllerManagerEntity

@end
