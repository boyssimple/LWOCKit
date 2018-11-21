//
//  YYDBManager.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYDatastore.h"
#import "YYApiObject.h"


@interface YYDBManager : YYDatastore

+ (YYDBManager *)defaultDataStore;

//查询数据库是不有记录，如果有则返回
- (id)aliveDataInDB:(YYApiObject *)tableAndItemKey;

//保存最新数据
- (void)saveDataToTable:(id)object withTableKey:(YYApiObject *)tableAndItemKey;

@end

