//
//  YYImgPickerManager.h
//  DiagnosisOnlineDoctor
//
//  Created by yanyu on 2019/7/12.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYImgPickerManager : NSObject
@property (nonatomic, assign) BOOL isAllowEdit;
@property (nonatomic, strong) void (^clickBlockAction)(UIImage *image);

- (void)showActionWithVC:(UIViewController*)vc withBlock:(void(^)(UIImage *image))block;

@end

NS_ASSUME_NONNULL_END
