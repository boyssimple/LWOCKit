//
//  YYApiObject.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYApiObject : NSObject
@property (nonatomic, assign) BOOL isHiddenHud;             //默认false (主要用于处理多个请求时自行处理hud)
//请求地址
- (NSString*)apiUrl;

//请求方法默认POST (POST、GET)
- (NSString*)method;

//是否缓存（默认不缓存）
- (BOOL)isCache;

//是否显示Hud
- (BOOL)isShowHud;

//加载提示信息
- (NSString*)hudTips;

//缓存数据表扩展名
- (NSString*)getTableNameExt;

/** 结合接口名称生成单次请求(表中单条数据)的唯一key  默认@""*/
- (NSString*)getItemIDExt;
@end

NS_ASSUME_NONNULL_END
