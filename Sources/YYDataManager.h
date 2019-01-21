//
//  YYDataManager.h
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LWOCKit/LWOCKitConfig.h>

//实例
@interface YYDataManageEntity : NSObject
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *identifiers;
@property  (nonatomic,assign)  CGFloat   cellHeaderHeight;
@property  (nonatomic,assign)  CGFloat   cellFooterHeight;
@property  (nonatomic,strong)  NSString    *headerView;
@property  (nonatomic,strong)  NSString    *footerView;
@property  (nonatomic,assign)  BOOL   canEdit;          //是否可以编辑
@property (nonatomic, assign) NSInteger tableSections;  //sections个数 (如果dataSource.count == 0就用tableSections)
@property (nonatomic, strong) NSArray *headerViews;     //多个header
@property (nonatomic, strong) NSArray *footerViews;     //多个footer
@property (nonatomic, strong) NSArray *indexs;          //索引
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
 左滑删除
 */
@property  (nonatomic,copy) BOOL (^canEditRowAtIndexPathBlock)(UITableView *table , YYDataManageEntity *model ,NSIndexPath *indexPath);

/**
 左滑删除
 */
@property  (nonatomic,copy) NSArray* (^editActionsForRowAtIndexPathBlock)(UITableView *table , YYDataManageEntity *model ,NSIndexPath *indexPath);


/**
 左滑删除事件 (默认删除事件 如果self.canEdit = TRUE时)
 */
@property  (nonatomic,copy) void (^deleteActionForRowAtIndexPathBlock)(UITableView *table , YYDataManageEntity *model ,NSIndexPath *indexPath);



/************* 多个header footer回调  *************/
@property  (nonatomic,copy) UIView* (^viewForHeaderInSectionReturnBlock)(UITableView *table , YYDataManageEntity *model ,NSInteger section);

@property  (nonatomic,copy) UIView* (^viewForFooterInSectionReturnBlock)(UITableView *table , YYDataManageEntity *model ,NSInteger section);

@property  (nonatomic,copy) void (^scrollViewDidScrollBlock)(UIScrollView* scrollView);
/**
 设置数据源
 
 @param entity 实例
 @param tableView table
 */
- (void)addDataSourceManagerEntity:(YYDataManageEntity*)entity withTableView:(UITableView*)tableView;
@end

