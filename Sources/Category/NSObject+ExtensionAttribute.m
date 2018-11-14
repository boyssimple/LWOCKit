//
//  NSObject+ExtensionAttribute.m
//  IM
//
//  Created by luowei on 2018/11/9.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "NSObject+ExtensionAttribute.h"
#import <objc/runtime.h>

@implementation NSObject (ExtensionAttribute)

- (void)setHeight:(CGFloat)height{
    objc_setAssociatedObject(self, @selector(height), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)height {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
@end
