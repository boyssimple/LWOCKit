//
//  YYDBManager.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYDBManager.h"

@implementation YYDBManager

+ (YYDBManager *)defaultDataStore {
    static YYDBManager *_ds = nil;
    static dispatch_once_t pisPatch;
    dispatch_once(&pisPatch, ^{
        _ds = [[YYDBManager alloc] initDBWithName:@"datastore.db"];
    });
    return _ds;
}


//查询数据库是不有记录，如果有则返回
- (id)aliveDataInDB:(YYApiObject *)tableAndItemKey {
    NSString *tableName = [self tableNameFromApiObject:tableAndItemKey];
    NSString *itemKey = [self itemKeyFromApiObject:tableAndItemKey];
    YYDataStoreItem *item = [self getYTKKeyValueItemById:itemKey fromTable:tableName];
    return item.itemObject;
}

//保存最新数据
- (void)saveDataToTable:(id)object withTableKey:(YYApiObject *)tableAndItemKey {
    NSString *tableName = [self tableNameFromApiObject:tableAndItemKey];
    NSString *itemKey = [self itemKeyFromApiObject:tableAndItemKey];
    [self deleteObjectById:itemKey fromTable:tableName];
    [self createTableWithName:tableName];
    [self putObject:object withId:itemKey intoTable:tableName];
}

- (NSString *)tableNameFromApiObject:(YYApiObject *)obj {
    NSString *tn = [[obj apiUrl] stringByReplacingOccurrencesOfString:@"/" withString:@""];//去掉非法字符
    tn = [NSString stringWithFormat:@"%@%@",tn,[obj getTableNameExt]];
    return tn;
}

- (NSString *)itemKeyFromApiObject:(YYApiObject *)obj {
    NSString *tn = [self tableNameFromApiObject:obj];
    NSString *ik = [NSString stringWithFormat:@"%@#||#%@",tn,[obj getItemIDExt]];
    return ik;
}

@end
