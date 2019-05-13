//
//  YYNetworkingConfig.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, RequestSerializerType) {
    RequestSerializerTypeJson = 1 << 0,
    RequestSerializerTypeHttp = 1 << 1
};

@interface YYNetworkingConfig : NSObject
+ (YYNetworkingConfig *)shareInstance;

// 服务器域名
@property (nonatomic, copy) NSString *hostUrl;

//状态参数名
@property (nonatomic, strong) NSString *status;//默认为@"code" (code == 200 请求成功)

//错误message参数名
@property (nonatomic, strong) NSString *message;//默认为@"msg" (msg = @"参数未传递")

//请求参数序列化方式
@property (nonatomic, assign) RequestSerializerType requestSerializerType;//RequestSerializerTypeHttp(AFHTTPRequestSerializer)默认，AFJSONRequestSerializer

//Header参数
@property (nonatomic, strong) NSMutableDictionary *headers;

//处理登录失效
@property (nonatomic, assign) NSInteger expireCode;         //失效code 默认401
@property (nonatomic, strong) void (^loginExpireBlock)(NSURLResponse * _Nonnull response, id  _Nullable responseObject);//失效回调
@end
