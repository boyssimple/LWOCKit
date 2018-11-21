//
//  YYDatastore.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface YYDataStoreItem : NSObject
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;
@end


@interface YYDatastore : NSObject

- (id)initDBWithName:(NSString *)dbName;

- (void)createTableWithName:(NSString *)tableName;

- (void)clearTable:(NSString *)tableName;

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (YYDataStoreItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

@end


