//
//  YYUploadManager.h
//  YIM_Example
//
//  Created by yanyu on 2019/7/8.
//  Copyright © 2019 boyssimple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YYUploadDataState) {
    YYUploadDataFailed,
    YYUploadDataSuccess
};
typedef NS_ENUM(NSInteger, YYUploadDataType) {
    YYUploadDataTypeImage,
    YYUploadDataTypeVideo,
    YYUploadDataTypeAudio,
    YYUploadDataTypeLocation,
    YYUploadDataTypeImageGIF,
};

@interface YYUploadManager : NSObject
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) NSString *bucket;
@property (nonatomic, strong) NSString *img_oss_url;
@property (nonatomic, strong) NSString *aliYunHost;

+ (instancetype)shared;

/**
 文件上传
 
 @param data 文件
 @param type 上传类型
 @param vc 所属vc
 @param complete 完成
 */
- (void)asyncUploadData:(NSData *)data Type:(YYUploadDataType )type
                 withVC:(UIViewController*)vc
               complete:(void(^)(NSArray<NSString *> *names,
                                 YYUploadDataState state,
                                 NSArray<NSString *> *urls))complete;


/**
 多文件上传
 
 @param datas 文件数组
 @param type 上传类型
 @param vc 所属vc
 @param complete 完成
 */
- (void)asyncUploadDatas:(NSArray<NSData *> *)datas Type:(YYUploadDataType )type
                  withVC:(UIViewController*)vc
                complete:(void(^)(NSArray<NSString *> *names,
                                  YYUploadDataState state,
                                  NSArray<NSString *> *urls))complete;

@end

