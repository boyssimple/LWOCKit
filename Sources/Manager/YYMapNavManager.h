//
//  YYMapNavManager.h
//  WisdomHotelCuster
//
//  Created by yanyu on 2019/10/16.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYMapNavManager : NSObject

+ (instancetype)shareInstance;

- (void)gotoAddress:(NSString*)address withView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
