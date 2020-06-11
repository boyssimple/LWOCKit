//
//  SQLocationManager.h
//  Audio
//
//  Created by yanyu on 2020/6/11.
//  Copyright © 2020 yanyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, SQLocationState) {
    SQLocationStateSuccess = 1 << 0,                //成功
    SQLocationStateFail = 1 << 1,                   //失败
    SQLocationStateDenied = 1 << 2,                 //无权限
};

typedef void(^SQLocationFinishedBlock)(SQLocationState state,CLLocationDegrees latitude,CLLocationDegrees longitude, NSString *_Nullable  province, NSString *_Nullable city, NSString *_Nullable area, NSString *_Nullable street);

@interface SQLocationManager : NSObject
+ (instancetype)share;
- (void)startLocationFinishedBlock:(SQLocationFinishedBlock)completion;
@end

NS_ASSUME_NONNULL_END
