//
//  YYNetworkManager.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYNetworkManager.h"

static NSTimeInterval   requestTimeout = 20.f;
@interface YYNetworkManager()
@property(nonatomic,strong)NSURLSessionConfiguration *configuration;
@property(nonatomic,strong)AFURLSessionManager *manager;
@end
@implementation YYNetworkManager

+ (YYNetworkManager *)shareManager{
    static YYNetworkManager *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[YYNetworkManager alloc]init];
    });
    
    return _client;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:_configuration];
        
        
        //配置响应序列化
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                          @"text/html",
                                                                          @"text/json",
                                                                          @"text/plain",
                                                                          @"text/javascript",
                                                                          @"text/xml",
                                                                          @"image/*",
                                                                          @"application/octet-stream",
                                                                          @"application/zip"]];
        _manager.responseSerializer = responseSerializer;
        
    }
    return self;
}

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
         failBlock:(HttpFailureBlock)failBlock{
    
    [self request:url view:view method:@"GET" refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
    
}


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
          failBlock:(HttpFailureBlock)failBlock{
    
    [self request:url view:view method:@"POST" refreshRequest:refresh cache:cache params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock];
    
}

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
                progress:(HttpDownloadProgressBlock)progress{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            if (success) {
                success(filePath,[response suggestedFilename]);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
    [downloadTask resume];
}

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
               progress:(HttpDownloadProgressBlock)progress{
    
    MBProgressHUD *hud;
    if (view) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:TRUE];
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
        hud.label.text = @"下载中...";
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
        hud.label.textColor = [UIColor whiteColor];
    }
    
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    directoryPath = [directoryPath stringByAppendingFormat:@"/%@/",dirName];
    
    BOOL isDir = FALSE;
    
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        
        BOOL bCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:TRUE attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"文件夹创建失败");
        }
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        if (progress) {
            progress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *u = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",directoryPath,[response suggestedFilename]]];
        return u;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (view) {
            [hud hideAnimated:TRUE];
        }
        if (!error) {
            if (success) {
                success(filePath,[response suggestedFilename]);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
    [downloadTask resume];
}

- (void)request:(NSString *)url
           view:(UIView*)view
         method:(NSString*)method
 refreshRequest:(BOOL)refresh
          cache:(BOOL)cache
         params:(NSDictionary *)params
  progressBlock:(HttpProgressBlock)progressBlock
   successBlock:(HttpSuccessBlock)successBlock
      failBlock:(HttpFailureBlock)failBlock{
    
    AFJSONRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = requestTimeout;
    requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    NSMutableURLRequest *request;
    
    if ([YYNetworkingConfig shareInstance].requestSerializerType == RequestSerializerTypeHttp) {
        AFHTTPRequestSerializer *requestSerializer =  [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        request = [requestSerializer requestWithMethod:method URLString:url parameters:params error:nil];
    }else{
        AFJSONRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        request = [requestSerializer requestWithMethod:method URLString:url parameters:params error:nil];
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (successBlock) {
                successBlock(responseObject);
            }
        }else{
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
}

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
                  view:(UIView *)view
         progressBlock:(HttpProgressBlock)progressBlock
          successBlock:(HttpSuccessBlock)successBlock
             failBlock:(HttpFailureBlock)failBlock{
    
    NSString *name = NSStringFromClass([obj class]);
    NSAssert([name hasPrefix:@"Req"], ([NSString stringWithFormat:@"%@，不是以Req开头",name]));
    NSAssert([name hasSuffix:@"Model"], ([NSString stringWithFormat:@"%@，不是以Model结尾",name]));
    NSAssert([obj isKindOfClass:[YYApiObject class]], ([NSString stringWithFormat:@"%@，未继承APIObject类",name]));
    NSAssert([obj apiUrl].length > 0, ([NSString stringWithFormat:@"%@，未设置url请求地址",name]));
    NSAssert([YYNetworkingConfig shareInstance].hostUrl.length > 0, ([NSString stringWithFormat:@"未设置HOST,设置方式：[YYNetworkingConfig shareInstance].hostUrl = @\"127.0.0.1\""]));
    if ([obj isCache]) {
        id dbObj = [[YYDBManager defaultDataStore] aliveDataInDB:obj];
        if (dbObj) {
            NSLog(@"获取到缓存数据:%@",dbObj);
            if (successBlock) {
                successBlock(dbObj);
            }
        }
    }
    
    //Hud
    MBProgressHUD *hud;
    if (!obj.isHiddenHud) {
        if ([obj isShowHud] && view) {
            hud = [MBProgressHUD showHUDAddedTo:view animated:TRUE];
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            
            hud.bezelView.backgroundColor = [UIColor blackColor];
            hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
            hud.label.textColor = [UIColor whiteColor];
            if ([obj hudTips]) {
                hud.label.text = [obj hudTips];
            }
        }
    }
    NSMutableURLRequest *request;
    NSMutableDictionary *params = [obj.mj_keyValues mutableCopy];
    if (params) {
        [params removeObjectForKey:@"isHiddenHud"];
    }
    NSMutableString *requestUrl = [[NSMutableString alloc]initWithFormat:@"%@%@",[YYNetworkingConfig shareInstance].hostUrl,[obj apiUrl]];
    if ([YYNetworkingConfig shareInstance].requestSerializerType == RequestSerializerTypeHttp) {
        AFHTTPRequestSerializer *requestSerializer =  [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }else{
        AFJSONRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            
            
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!obj.isHiddenHud) {
            if ([obj isShowHud] && view) {
                [hud hideAnimated:TRUE];
            }
        }
        if (!error) {
            if (responseObject){
                
                if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].successCode){
                    if ([obj isCache]) {
                        [[YYDBManager defaultDataStore] saveDataToTable:responseObject withTableKey:obj];
                    }
                    [self successNetworking:name obj:obj result:responseObject];
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }else if([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].expireCode){
                    //处理失效回调
                    if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                        [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                    }
                    if (failBlock) {
                        failBlock(error);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == 5) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERLOGINFAILED object:nil];
                    if (failBlock) {
                        failBlock(error);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else{
                    NSString *message = [responseObject jk_stringForKey:[YYNetworkingConfig shareInstance].message];
                    [MBProgressHUD showError:message toView:view timeDelay:2.0 finishBlock:^{
                        
                    }];
                    if (failBlock) {
                        failBlock(error);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }
            }
        }else{
            //处理登录失效问题
            NSHTTPURLResponse *res =  (NSHTTPURLResponse*)response;
            if(res && res.statusCode == [YYNetworkingConfig shareInstance].expireCode){
                //处理失效回调
                if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                    [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                }
                return;
            }

            if (![YYNetworkingConfig shareInstance].isHiddenRequestFailHud) {
                [MBProgressHUD showError:@"连接服务器失败" toView:view timeDelay:2.0 finishBlock:^{
                    
                }];
            }
            [self failureNetworking:name obj:obj result:error withResponse:responseObject];
            if (failBlock) {
                failBlock(error);
            }
        }
    }];
    [dataTask resume];
}

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
                  view:(UIView *)view
         progressBlock:(HttpProgressBlock)progressBlock
          successBlock:(HttpSuccessBlock)successBlock
         failBackBlock:(HttpFailureBackBlock)failBlock{
    
    NSString *name = NSStringFromClass([obj class]);
    NSAssert([name hasPrefix:@"Req"], ([NSString stringWithFormat:@"%@，不是以Req开头",name]));
    NSAssert([name hasSuffix:@"Model"], ([NSString stringWithFormat:@"%@，不是以Model结尾",name]));
    NSAssert([obj isKindOfClass:[YYApiObject class]], ([NSString stringWithFormat:@"%@，未继承APIObject类",name]));
    NSAssert([obj apiUrl].length > 0, ([NSString stringWithFormat:@"%@，未设置url请求地址",name]));
    NSAssert([YYNetworkingConfig shareInstance].hostUrl.length > 0, ([NSString stringWithFormat:@"未设置HOST,设置方式：[YYNetworkingConfig shareInstance].hostUrl = @\"127.0.0.1\""]));
    if ([obj isCache]) {
        id dbObj = [[YYDBManager defaultDataStore] aliveDataInDB:obj];
        if (dbObj) {
            NSLog(@"获取到缓存数据:%@",dbObj);
            if (successBlock) {
                successBlock(dbObj);
            }
        }
    }
    
    //Hud
    MBProgressHUD *hud;
    if (!obj.isHiddenHud) {
        if ([obj isShowHud] && view) {
            hud = [MBProgressHUD showHUDAddedTo:view animated:TRUE];
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            
            hud.bezelView.backgroundColor = [UIColor blackColor];
            hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
            hud.label.textColor = [UIColor whiteColor];
            if ([obj hudTips]) {
                hud.label.text = [obj hudTips];
            }
        }
    }
    NSMutableURLRequest *request;
    NSMutableDictionary *params = [obj.mj_keyValues mutableCopy];
    if (params) {
        [params removeObjectForKey:@"isHiddenHud"];
    }
    NSMutableString *requestUrl = [[NSMutableString alloc]initWithFormat:@"%@%@",[YYNetworkingConfig shareInstance].hostUrl,[obj apiUrl]];
    if ([YYNetworkingConfig shareInstance].requestSerializerType == RequestSerializerTypeHttp) {
        AFHTTPRequestSerializer *requestSerializer =  [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            
            
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }else{
        AFJSONRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            
            
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!obj.isHiddenHud) {
            if ([obj isShowHud] && view) {
                [hud hideAnimated:TRUE];
            }
        }
        if (!error) {
            if (responseObject){
                
                if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].successCode){
                    if ([obj isCache]) {
                        [[YYDBManager defaultDataStore] saveDataToTable:responseObject withTableKey:obj];
                    }
                    [self successNetworking:name obj:obj result:responseObject];
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }else if([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].expireCode){
                    //处理失效回调
                    if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                        [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                    }
                    if (failBlock) {
                        failBlock(error,[responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status]);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == 5) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERLOGINFAILED object:nil];
                    if (failBlock) {
                        failBlock(error,[responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status]);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else{
                    NSString *message = [responseObject jk_stringForKey:[YYNetworkingConfig shareInstance].message];
                    [MBProgressHUD showError:message toView:view timeDelay:2.0 finishBlock:^{
                        
                    }];
                    if (failBlock) {
                        failBlock(error,[responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status]);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }
            }
        }else{
            NSHTTPURLResponse *res =  (NSHTTPURLResponse*)response;
            if(res && res.statusCode == [YYNetworkingConfig shareInstance].expireCode){
                //处理失效回调
                if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                    [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                }
                return;
            }
            if (![YYNetworkingConfig shareInstance].isHiddenRequestFailHud) {
               [MBProgressHUD showError:@"连接服务器失败" toView:view timeDelay:2.0 finishBlock:^{
                   
               }];
            }
            [self failureNetworking:name obj:obj result:error withResponse:responseObject];
            if (failBlock) {
                failBlock(error,0);
            }
        }
    }];
    [dataTask resume];
}
/**
 *  POST请求
 *
 *  @param obj              请求对象
 *  @param view             view
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调 (返回后台数据)
 *
 */
- (void)requestWithObj:(YYApiObject*)obj
                  view:(UIView *)view
         progressBlock:(HttpProgressBlock)progressBlock
          successBlock:(HttpSuccessBlock)successBlock
       failResultBlock:(HttpFailureResultBlock)failBlock{
    NSString *name = NSStringFromClass([obj class]);
    NSAssert([name hasPrefix:@"Req"], ([NSString stringWithFormat:@"%@，不是以Req开头",name]));
    NSAssert([name hasSuffix:@"Model"], ([NSString stringWithFormat:@"%@，不是以Model结尾",name]));
    NSAssert([obj isKindOfClass:[YYApiObject class]], ([NSString stringWithFormat:@"%@，未继承APIObject类",name]));
    NSAssert([obj apiUrl].length > 0, ([NSString stringWithFormat:@"%@，未设置url请求地址",name]));
    NSAssert([YYNetworkingConfig shareInstance].hostUrl.length > 0, ([NSString stringWithFormat:@"未设置HOST,设置方式：[YYNetworkingConfig shareInstance].hostUrl = @\"127.0.0.1\""]));
    if ([obj isCache]) {
        id dbObj = [[YYDBManager defaultDataStore] aliveDataInDB:obj];
        if (dbObj) {
            NSLog(@"获取到缓存数据:%@",dbObj);
            if (successBlock) {
                successBlock(dbObj);
            }
        }
    }
    
    //Hud
    MBProgressHUD *hud;
    if (!obj.isHiddenHud) {
        if ([obj isShowHud] && view) {
            hud = [MBProgressHUD showHUDAddedTo:view animated:TRUE];
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            
            hud.bezelView.backgroundColor = [UIColor blackColor];
            hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
            hud.label.textColor = [UIColor whiteColor];
            if ([obj hudTips]) {
                hud.label.text = [obj hudTips];
            }
        }
    }
    NSMutableURLRequest *request;
    NSMutableDictionary *params = [obj.mj_keyValues mutableCopy];
    if (params) {
        [params removeObjectForKey:@"isHiddenHud"];
    }
    NSMutableString *requestUrl = [[NSMutableString alloc]initWithFormat:@"%@%@",[YYNetworkingConfig shareInstance].hostUrl,[obj apiUrl]];
    if ([YYNetworkingConfig shareInstance].requestSerializerType == RequestSerializerTypeHttp) {
        AFHTTPRequestSerializer *requestSerializer =  [AFHTTPRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            
            
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }else{
        AFJSONRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        requestSerializer.timeoutInterval = requestTimeout;
        requestSerializer.stringEncoding = NSUTF8StringEncoding;
        //Header
        NSArray * array = [[YYNetworkingConfig shareInstance].headers allKeys];
        for (NSString * key in array) {
            NSString *v = [[YYNetworkingConfig shareInstance].headers objectForKey:key];
            [requestSerializer setValue:v forHTTPHeaderField:key];
        }
        
        if ([obj isRestful]) {
            //处理restful参数
            if ([obj restfulParam].count > 0) {
                for (NSString *key in [obj restfulParam]) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                //去掉除restful参数
                for (NSString *key in [obj restfulParam]) {
                    [params removeObjectForKey:key];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
            }else{
                NSArray *allKeys = [params allKeys];
                for (NSString *key in allKeys) {
                    [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                }
                
                
                for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                    NSString *key = [[obj queryParams] objectAtIndex:i];
                    if (i == 0) {
                        [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                    }else{
                        [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                    }
                }
                for (NSString *key in [obj queryParams]) {
                    [params removeObjectForKey:key];
                }
                request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:nil error:nil];
            }
        
        }else{
            
            
            for (NSInteger i = 0; i< [obj queryParams].count; i++) {
                NSString *key = [[obj queryParams] objectAtIndex:i];
                if (i == 0) {
                    [requestUrl appendFormat:@"?%@=%@",key,[params objectForKey:key]];
                }else{
                    [requestUrl appendFormat:@"&%@=%@",key,[params objectForKey:key]];
                }
            }
            for (NSString *key in [obj queryParams]) {
                [params removeObjectForKey:key];
            }
            request = [requestSerializer requestWithMethod:[obj method] URLString:requestUrl parameters:params error:nil];
        }
    }
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!obj.isHiddenHud) {
            if ([obj isShowHud] && view) {
                [hud hideAnimated:TRUE];
            }
        }
        if (!error) {
            if (responseObject){
                
                if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].successCode){
                    if ([obj isCache]) {
                        [[YYDBManager defaultDataStore] saveDataToTable:responseObject withTableKey:obj];
                    }
                    [self successNetworking:name obj:obj result:responseObject];
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }else if([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == [YYNetworkingConfig shareInstance].expireCode){
                    //处理失效回调
                    if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                        [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                    }
                    if (failBlock) {
                        failBlock(error,responseObject);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else if ([responseObject jk_integerForKey:[YYNetworkingConfig shareInstance].status] == 5) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERLOGINFAILED object:nil];
                    if (failBlock) {
                        failBlock(error,responseObject);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }else{
                    NSString *message = [responseObject jk_stringForKey:[YYNetworkingConfig shareInstance].message];
                    [MBProgressHUD showError:message toView:view timeDelay:2.0 finishBlock:^{
                        
                    }];
                    if (failBlock) {
                        failBlock(error,responseObject);
                    }
                    [self failureNetworking:name obj:obj result:error withResponse:responseObject];
                }
            }
        }else{
            NSHTTPURLResponse *res =  (NSHTTPURLResponse*)response;
            if(res && res.statusCode == [YYNetworkingConfig shareInstance].expireCode){
                //处理失效回调
                if ([YYNetworkingConfig shareInstance].loginExpireBlock) {
                    [YYNetworkingConfig shareInstance].loginExpireBlock(response, responseObject);
                }
                return;
            }
            if (![YYNetworkingConfig shareInstance].isHiddenRequestFailHud) {
                [MBProgressHUD showError:@"连接服务器失败" toView:view timeDelay:2.0 finishBlock:^{
                    
                }];
            }
            [self failureNetworking:name obj:obj result:error withResponse:responseObject];
            if (failBlock) {
                failBlock(error,0);
            }
        }
    }];
    [dataTask resume];
}

- (void)successNetworking:(NSString*)name obj:(YYApiObject*)obj result:(id)result{
    NSMutableURLRequest *request;
    NSMutableDictionary *params = [obj.mj_keyValues mutableCopy];
    if (params) {
        [params removeObjectForKey:@"isHiddenHud"];
    }
    
    
    NSMutableString *requestUrl = [[NSMutableString alloc]initWithFormat:@"%@%@",[YYNetworkingConfig shareInstance].hostUrl,[obj apiUrl]];
    
    if ([obj isRestful]) {
        //处理restful参数
        if ([obj restfulParam].count > 0) {
            NSMutableArray *restFullarr = [[NSMutableArray alloc]init];
            for (NSString *key in [obj restfulParam]) {
                [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                [restFullarr addObject:@{key:[params objectForKey:key]}];
            }
            //去掉除restful参数
            for (NSString *key in [obj restfulParam]) {
                [params removeObjectForKey:key];
            }
            NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\nrestFul参数：%@\n普通参数：%@\n请求结果：%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,restFullarr,params,result);
        }else{
            NSArray *allKeys = [params allKeys];
            for (NSString *key in allKeys) {
                [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
            }
            NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\nrestFul参数：%@\n请求结果：%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,params,result);
        }
    
    }else{
        NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\n请求参数：%@\n请求结果：%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,params,result);
    }
}

- (void)failureNetworking:(NSString*)name obj:(YYApiObject*)obj result:(NSError*)error withResponse:(id  _Nullable)responseObject{
    NSMutableURLRequest *request;
    NSMutableDictionary *params = [obj.mj_keyValues mutableCopy];
    if (params) {
        [params removeObjectForKey:@"isHiddenHud"];
    }
    
    
    NSMutableString *requestUrl = [[NSMutableString alloc]initWithFormat:@"%@%@",[YYNetworkingConfig shareInstance].hostUrl,[obj apiUrl]];
    
    if ([obj isRestful]) {
        //处理restful参数
        if ([obj restfulParam].count > 0) {
            NSMutableArray *restFullarr= [[NSMutableArray alloc]init];
            for (NSString *key in [obj restfulParam]) {
                [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
                [restFullarr addObject:@{key:[params objectForKey:key]}];
            }
            //去掉除restful参数
            for (NSString *key in [obj restfulParam]) {
                [params removeObjectForKey:key];
            }
            
            NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\nrestFul参数：%@\n普通参数：%@\n请求错误：%@\n%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,restFullarr,params,error,responseObject);
        }else{
            NSArray *allKeys = [params allKeys];
            for (NSString *key in allKeys) {
                [requestUrl appendFormat:@"/%@",[params objectForKey:key]];
            }
            NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\nrestFul参数：%@\n请求错误：%@\n%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,params,error,responseObject);
        }
    
    }else{
        NSLog(@"\n**********************网络请求开始**********************\n请求模型：%@\n请求地址：%@\nHeader参数：%@\n请求参数：%@\n请求错误：%@\n%@\n**********************网络请求结束**********************",name,requestUrl,[YYNetworkingConfig shareInstance].headers,params,error,responseObject);
    }
}
@end
