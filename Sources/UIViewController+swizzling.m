//
//  UIViewController+swizzling.m
//  UMa
//
//  Created by simple on 2018/5/30.
//  Copyright © 2018年 yanyu. All rights reserved.
//

#import "UIViewController+swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (swizzling) 
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(viewWillAppear:);
        SEL swizzSel = @selector(swiz_viewWillAppear:);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
        //viewWillDisappear
        SEL systemSel2 = @selector(viewWillDisappear:);
        SEL swizzSel2 = @selector(swiz_viewWillDisappear:);
        Method systemMethod2 = class_getInstanceMethod([self class], systemSel2);
        Method swizzMethod2 = class_getInstanceMethod([self class], swizzSel2);
        
        BOOL isAdd2 = class_addMethod(self, systemSel2, method_getImplementation(swizzMethod2), method_getTypeEncoding(swizzMethod2));
        if (isAdd2) {
            class_replaceMethod(self, swizzSel2, method_getImplementation(systemMethod2), method_getTypeEncoding(systemMethod2));
        }else{
            method_exchangeImplementations(systemMethod2, swizzMethod2);
        }
        
        
        //viewDidLoad
        SEL systemViewDidLoad = @selector(viewDidLoad);
        SEL swizzViewDidLoad = @selector(swiz_viewDidLoad);
        Method systemMethodSecond = class_getInstanceMethod([self class], systemViewDidLoad);
        Method swizzMethodSecond = class_getInstanceMethod([self class], swizzViewDidLoad);
        
        BOOL isAddSecond = class_addMethod(self, systemViewDidLoad, method_getImplementation(swizzMethodSecond), method_getTypeEncoding(swizzMethodSecond));
        if (isAddSecond) {
            class_replaceMethod(self, swizzViewDidLoad, method_getImplementation(systemMethodSecond), method_getTypeEncoding(systemMethodSecond));
        }else{
            method_exchangeImplementations(systemMethodSecond, swizzMethodSecond);
        }
        
        //delloc
        method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                       
                                       class_getInstanceMethod(self.class, @selector(swiz_dealloc)));
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated{
    [self swiz_viewWillAppear:animated];
    NSString *name = self.navigationItem.title;
    if(!name){
        name = self.title;
    }
    if(!name){
        name = @"";
    }
    NSLog(@"当前控制器：%@ -- %@",self.class,name);
    //处理是否改变导航为红色
    if ([self changeNavigationBarRedColor]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    if([self isLightContentStatus]){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)swiz_viewWillDisappear:(BOOL)animated{
    [self swiz_viewWillDisappear:animated];
}

- (BOOL)isLightContentStatus{
    return TRUE;
}

- (void)swiz_viewDidLoad{
    if ([self isRefreshData]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refereshDataHandle) name:REFRESH_ALL_DATA object:nil];
    }
}

- (BOOL)changeNavigationBarRedColor{
    return TRUE;
}

- (BOOL)isRefreshData{
    return FALSE;
}

- (void)refereshDataHandle{
    
}

- (BOOL)isHiddenNavigation{
    return FALSE;
}

-(void)swiz_dealloc{
    
    if ([self isRefreshData]) {
        NSLog(@"去掉当前视图通知......");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [self swiz_dealloc];
}

- (void)refreshPlatformInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ALL_DATA object:nil];
}
@end
