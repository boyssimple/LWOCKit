//
//  YYBaseWindow.h
//  OKVoice
//
//  Created by yanyu on 2018/12/28.
//  Copyright © 2018年 luowei. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YYBaseWindowType) {
    YYBaseWindowTypeToast = 1 << 0,
    YYBaseWindowTypeSlide = 1 << 1
};

static UIWindow *baseWindow = nil;

@interface YYBaseWindow : UIWindow
@property (nonatomic, assign) YYBaseWindowType type;
@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, assign) CGFloat grayAlpha;
- (id)initWithType:(YYBaseWindowType)type;

- (void)show;
- (void)dismiss;

@end
