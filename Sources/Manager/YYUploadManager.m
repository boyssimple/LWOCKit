//
//  YYUploadManager.m
//  YIM_Example
//
//  Created by yanyu on 2019/7/8.
//  Copyright © 2019 boyssimple. All rights reserved.
//

#import "YYUploadManager.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#import <MBProgressHUD/MBProgressHUD.h>



@implementation YYUploadManager

+ (instancetype)shared {
    static YYUploadManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[YYUploadManager alloc] init];
    });
    return client;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)asyncUploadData:(NSData *)data Type:(YYUploadDataType )type
                 withVC:(UIViewController*)vc
               complete:(void(^)(NSArray<NSString *> *names,
                                 YYUploadDataState state,
                                 NSArray<NSString *> *urls))complete{
    
    
    [self uploadDatas:@[data] isAsync:YES Type:type withVC:vc complete:complete];
}

- (void)uploadDatas:(NSArray<NSData *> *)datas isAsync:(BOOL)isAsync Type:(YYUploadDataType)type withVC:(UIViewController*)vc complete:(void(^)(NSArray<NSString *> *names, YYUploadDataState state,NSArray<NSString *> *urls))complete
{
    MBProgressHUD *hud;
    
    if (vc) {
        hud = [MBProgressHUD showHUDAddedTo:vc.view animated:TRUE];
        hud.bezelView.backgroundColor = [UIColor blackColor];
    }
    
    
    NSString *accessKey = self.accessKey;//@"LTAIaG4xRSysuIAp";
    NSString *secretKey = self.secretKey;//@"p5VT8YDKFxHmFNbEq8K0Hr1x9AkXY2";
    NSString *dir = self.dir;//@"";
    NSString *bucket = self.bucket;//@"okyuyin";
#pragma clang diagnostic push
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:accessKey                                                                                                           secretKey:secretKey];
#pragma clang diagnostic pop
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:self.aliYunHost credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = datas.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (NSData *data in datas) {
        if (data) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = bucket;
                NSString *imageName = @"";
                if (type == YYUploadDataTypeImage){
                    imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".png"]];
                }else if (type == YYUploadDataTypeImageGIF){
                    imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".gif"]];
                }else if (type == YYUploadDataTypeVideo){
                    imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".mp4"]];
                }else{
                    imageName = [dir stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".acc"]];
                }
                put.objectKey = imageName;
                [callBackNames addObject:imageName];
                
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"上传文件成功!");
                } else {
                    NSLog(@"上传文件失败, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (data == datas.lastObject) {
                        NSLog(@"upload object finished!");
                        if (complete) {
                            if (vc) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:TRUE];
                                });
                            }
                            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:callBackNames.count];
                            for (NSString *url in callBackNames) {
                                if ( ![url containsString:@"http://"]) { //添加图片地址前缀
                                    NSString *newUrl = [NSString stringWithFormat:@"http://%@.%@%@",self.bucket,self.img_oss_url,url];
                                    [urls addObject:newUrl];
                                }
                            }
                            complete([NSArray arrayWithArray:callBackNames] ,YYUploadDataSuccess,urls);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        NSLog(@"haha");
        if (complete) {
            if (complete) {
                NSMutableArray *urls = [NSMutableArray arrayWithCapacity:callBackNames.count];
                for (NSString *url in callBackNames) {
                    if ( ![url containsString:@"http://"]) { //添加图片地址前缀
                        NSString *newUrl = [NSString stringWithFormat:@"http://%@.%@%@",self.bucket,self.img_oss_url,url];
                        [urls addObject:newUrl];
                    }
                }
                complete([NSArray arrayWithArray:callBackNames], YYUploadDataSuccess,urls);
            }
        }
    }
}

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
                                  NSArray<NSString *> *urls))complete{
    
    [self uploadDatas:datas isAsync:YES Type:type withVC:vc complete:complete];
}
@end
