//
//  YYVersionManager.h
//  DiagnosisOnlineDoctor
//
//  Created by yanyu on 2019/7/13.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import "YYApiObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYVersionManager : YYApiObject
@property (nonatomic, strong) NSString *appId;              //app id (app stores中的id)
@property (nonatomic, strong) NSString *url;                //下载地址
+ (instancetype)shared;

/**
 检查是否有新版本
 */
- (void)checkVersion;

/**
 更新版本
 */
- (void)updateVersion;
@end

NS_ASSUME_NONNULL_END
