//
//  YYWindowSetHost.h
//  KaKaWorking
//
//  Created by yanyu on 2019/9/18.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import <LWOCKit/YYBaseWindow.h>

static UIWindow *yySetHostWindow = nil;
@interface YYWindowSetHost : UIWindow

- (id)init;

- (void)show;
- (void)dismiss;
@end

