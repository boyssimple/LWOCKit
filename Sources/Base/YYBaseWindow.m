//
//  YYBaseWindow.m
//  OKVoice
//
//  Created by yanyu on 2018/12/28.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYBaseWindow.h"

@implementation YYBaseWindow

- (id)initWithType:(YYBaseWindowType)type
{
    self = [super initWithFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    if (self) {
        self.type = type;
        self.windowLevel = UIWindowLevelAlert;
        baseWindow = self;
        _grayAlpha = 0.6;
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICEWIDTH, DEVICEHEIGHT)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView.userInteractionEnabled = YES;
        [self addSubview:_grayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_grayView addGestureRecognizer:tap];
        
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(10*RATIO_HEIGHT750, DEVICEHEIGHT, DEVICEWIDTH - 20*RATIO_WIDHT750, 240*RATIO_HEIGHT750+1)];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 5;
        _mainView.clipsToBounds = TRUE;
        [self addSubview:_mainView];
    }
    
    return self;
}


- (void)dealloc{
    NSLog(@"[DEBUG] delloc:%@",self);
}


- (void)show {
    [self makeKeyAndVisible];
    __weak typeof(self) weakself = self;
    if (self.type == YYBaseWindowTypeSlide) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect  r = self.mainView.frame;
            weakself.grayView.alpha = weakself.grayAlpha;
            r.origin.y = DEVICEHEIGHT - r.size.height;
            weakself.mainView.frame = r;
        }];
    } else{
        CGRect  r = self.mainView.frame;
        r.origin.y = (DEVICEHEIGHT - r.size.height)/2.0;
        weakself.mainView.frame = r;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.grayView.alpha = weakself.grayAlpha;
            weakself.mainView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)dismiss {
    __weak typeof(self) weakself = self;
    
    if (self.type == YYBaseWindowTypeSlide) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect r = self.mainView.frame;
            weakself.grayView.alpha = 0;
            r.origin.y = DEVICEHEIGHT;
            weakself.mainView.frame = r;
        } completion:^(BOOL finished) {
            [baseWindow removeAllSubviews];
            [self resignKeyWindow];
            baseWindow = nil;
        }];
    } else{
        [UIView animateWithDuration:0.3 animations:^{
            weakself.grayView.alpha = 0;
            weakself.mainView.alpha = 0;
        } completion:^(BOOL finished) {
            [baseWindow removeAllSubviews];
            [self resignKeyWindow];
            baseWindow = nil;
        }];
        
    }
}

@end
