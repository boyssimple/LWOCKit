//
//  YYNetworkManager.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <LWOCKit/LWOCKitConfig.h>
#import "YYApiObject.h"
#import "YYNetworkingConfig.h"
#import "YYDBManager.h"

typedef void(^HttpSuccessBlock)(id responseObject);
typedef void(^HttpFailureBlock)(NSError *error);
typedef void(^HttpFailureBackBlock)(NSError *error,long code);
typedef void(^HttpProgressBlock)(CGFloat progress);

typedef void(^HttpDownSuccessBlock)(NSURL *filePath,NSString *name);
typedef void(^HttpDownloadProgressBlock)(CGFloat progress);
typedef void(^HttpUploadProgressBlock)(CGFloat progress);

@interface YYNetworkManager : NSObject


/**
 单例
 
 @return 返回实例
 */
+ (YYNetworkManager *)shareManager;

/**
 *  GET请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请   求，用旧请求)
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 */
- (void)getWithUrl:(NSString *)url
              view:(UIView*)view
    refreshRequest:(BOOL)refresh
             cache:(BOOL)cache
            params:(NSDictionary *)params
     progressBlock:(HttpProgressBlock)progressBlock
      successBlock:(HttpSuccessBlock)successBlock
         failBlock:(HttpFailureBlock)failBlock;


/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请   求，用旧请求)
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 */
- (void)postWithUrl:(NSString *)url
               view:(UIView*)view
     refreshRequest:(BOOL)refresh
              cache:(BOOL)cache
             params:(NSDictionary *)params
      progressBlock:(HttpProgressBlock)progressBlock
       successBlock:(HttpSuccessBlock)successBlock
          failBlock:(HttpFailureBlock)failBlock;

/**
 下载文件
 
 @param path url路径
 @param success 下载成功
 @param failure 下载失败
 @param progress 下载进度
 */
- (void)downloadWithPath:(NSString *)path
                    view:(UIView*)view
                 success:(HttpDownSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress;

/**
 下载文件
 
 @param path url路径
 @param dirName 目录名称
 @param success 下载成功
 @param failure 下载失败
 @param progress 下载进度
 */
- (void)downloadWithUrl:(NSString *)url
                dirName:(NSString*)dirName
                   view:(UIView*)view
                success:(HttpDownSuccessBlock)success
                failure:(HttpFailureBlock)failure
               progress:(HttpDownloadProgressBlock)progress;


/**
 上传图片
 
 @param path url地址
 @param images NSArray对象 多图片上传
 @param thumbName imagekey
 @param params 上传参数
 @param success 上传成功
 @param failure 上传失败
 @param progress 上传进度
 */
- (void)uploadImageWithPath:(NSString *)path
                       view:(UIView*)view
                     params:(NSDictionary *)params
                  thumbName:(NSString *)thumbName
                      image:(NSArray *)images
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;

/**
 *  POST请求
 *
 *  @param obj              请求对象
 *  @param view             view
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 */
- (void)requestWithObj:(YYApiObject*)obj
                  view:(UIView*)view
         progressBlock:(HttpProgressBlock)progressBlock
          successBlock:(HttpSuccessBlock)successBlock
             failBlock:(HttpFailureBlock)failBlock;

/**
 *  POST请求
 *
 *  @param obj              请求对象
 *  @param view             view
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调 (有返回code)
 *
 */
- (void)requestWithObj:(YYApiObject*)obj
                  view:(UIView *)view
         progressBlock:(HttpProgressBlock)progressBlock
          successBlock:(HttpSuccessBlock)successBlock
         failBackBlock:(HttpFailureBackBlock)failBlock;

@end
