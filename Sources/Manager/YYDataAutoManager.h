//
//  YYDataAutoManager.h
//  AFNetworking
//
//  Created by luowei on 2019/4/14.
//

#import <Foundation/Foundation.h>
#import <LWOCKit/LWOCKitConfig.h>

NS_ASSUME_NONNULL_BEGIN

//协议代理
@protocol YYDataAutoManagerDelegate <NSObject>

@optional
- (void)refreshDataWithTable:(UITableView*)table;

@end
@interface YYDataAutoManager : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)id<YYDataAutoManagerDelegate> delegate;

/**
 cell配置
 */
@property (nonatomic, strong) UITableViewCell* (^cellForRowAtIndexPathBlock)(UITableView *table,YYDataManageEntity *entity,NSIndexPath *indexPath);

/**
 table 中的section的数量
 */
@property (nonatomic, strong) NSInteger (^numberOfSectionsInTableViewBlock)(UITableView *table,YYDataManageEntity *entity);


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

NS_ASSUME_NONNULL_END
