//
//  UIViewController+Refresh.m
//  Project
//
//  Created by luowei on 2018/11/15.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "UIViewController+Refresh.h"
#import <objc/runtime.h>

@implementation UIViewController (Refresh)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //viewWillAppear
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
}

- (void)swiz_viewDidLoad{
    if ([self isRefreshData]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refereshDataHandle) name:REFRESH_ALL_DATA object:nil];
    }
}

- (BOOL)isRefreshData{
    return FALSE;
}

- (void)refereshDataHandle{
    
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
