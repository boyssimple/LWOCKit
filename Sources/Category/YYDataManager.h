//
//  YYDataManager.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITypes+extionsion.h"

//实例
@interface YYDataManageEntity : NSObject
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *identifiers;
@property  (nonatomic,assign)  CGFloat   cellHeaderHeight;
@property  (nonatomic,assign)  CGFloat   cellFooterHeight;
@property  (nonatomic,strong)  NSString    *headerView;
@property  (nonatomic,strong)  NSString    *footerView;
@end

//协议代理
@protocol YYDataManagerDelegate <NSObject>

- (void)refreshDataWithTable:(UITableView*)table;

@end

@interface YYDataManager : NSObject<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)id<YYDataManagerDelegate> delegate;

/**
 cell配置
 */
@property (nonatomic, strong) UITableViewCell* (^cellForRowAtIndexPathBlock)(UITableView *table,YYDataManageEntity *entity,NSIndexPath *indexPath);

/**
 高度
 */
@property (nonatomic, strong) CGFloat (^heightForRowAtIndexPathBlock)(NSIndexPath *indexPath);

/**
 section中的行的数量
 */
@property (nonatomic, strong) NSInteger (^numberOfRowsInSectionBlock)(NSInteger section);

/**
 cell 点击事件回调
 */
@property  (nonatomic,copy) void (^didSelectRowAtIndexPathBlock)(UITableViewCell *cell , YYDataManageEntity *model ,NSIndexPath *indexPath);

/**
 Header回调
 */
@property  (nonatomic,copy) void (^viewForHeaderInSectionBlock)(UIView *header , YYDataManageEntity *model ,NSInteger section);

/**
 Footer回调
 */
@property  (nonatomic,copy) void (^viewForFooterInSectionBlock)(UIView *footer , YYDataManageEntity *model ,NSInteger section);

/**
 Header 高度
 */
@property  (nonatomic,copy) CGFloat (^heightForHeaderInSectionBlock)(UITableView *table , YYDataManageEntity *model ,NSInteger section);

/**
 Footer 高度
 */
@property  (nonatomic,copy) CGFloat (^heightForFooterInSectionBlock)(UITableView *table , YYDataManageEntity *model ,NSInteger section);



/**
 设置数据源

 @param entity 实例
 @param tableView table
 */
- (void)addDataSourceManagerEntity:(YYDataManageEntity*)entity withTableView:(UITableView*)tableView;
@end

