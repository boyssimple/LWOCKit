//
//  YYCollectionDataManager.h
//  Project
//
//  Created by luowei on 2018/11/26.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LWOCKit/LWOCKitConfig.h>

//实例
@interface YYCollectionDataManageEntity : NSObject
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *identifiers;
@property  (nonatomic,assign)  CGSize   cellHeaderSize;
@property  (nonatomic,assign)  CGSize   cellFooterSize;
@property  (nonatomic,strong)  NSString    *headerView;
@property  (nonatomic,strong)  NSString    *footerView;
@property  (nonatomic,assign)  BOOL   canEdit;          //是否可以编辑
@property (nonatomic, assign) NSInteger tableSections;  //sections个数 (如果dataSource.count == 0就用tableSections)
@end

//协议代理
@protocol YYCollectionDataManagerDelegate <NSObject>

- (void)refreshDataWithCollection:(UICollectionView*)collectionView;

@end

@interface YYCollectionDataManager : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)id<YYCollectionDataManagerDelegate> delegate;
/**
 cell配置
 */
@property (nonatomic, strong) UICollectionViewCell* (^cellForRowAtIndexPathBlock)(UICollectionView *collectionView,YYCollectionDataManageEntity *entity,NSIndexPath *indexPath);

/**
 section中的行的数量
 */
@property (nonatomic, strong) NSInteger (^numberOfRowsInSectionBlock)(NSInteger section);

/**
 高度
 */
@property (nonatomic, strong) CGSize (^sizeForItemAtIndexPathBlock)(NSIndexPath *indexPath);

/**
 cell 点击事件回调
 */
@property  (nonatomic,copy) void (^didSelectItemAtIndexPathBlock)(UICollectionView *collectionView , YYCollectionDataManageEntity *model ,NSIndexPath *indexPath);


/**
 Header 高度
 */
@property  (nonatomic,copy) CGSize (^heightForHeaderInSectionBlock)(UICollectionView *collectionView , YYCollectionDataManageEntity *model ,NSInteger section);

/**
 Header回调
 */
@property  (nonatomic,copy) void (^viewForHeaderInSectionBlock)(UICollectionReusableView *header , YYCollectionDataManageEntity *model ,NSIndexPath * indexPath);

/**
 Footer 高度
 */
@property  (nonatomic,copy) CGSize (^heightForFooterInSectionBlock)(UICollectionView *collectionView , YYCollectionDataManageEntity *model ,NSInteger section);

/**
 Footer回调
 */
@property  (nonatomic,copy) void (^viewForFooterInSectionBlock)(UICollectionReusableView *footer , YYCollectionDataManageEntity *model ,NSIndexPath * indexPath);



/**
 设置数据源

 @param entity 实例
 @param collectionView collection
 */
- (void)addDataSourceManagerEntity:(YYCollectionDataManageEntity*)entity withTableView:(UICollectionView*)collectionView;
@end
