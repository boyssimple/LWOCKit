//
//  YYDataManageEntity.h
//  AFNetworking
//
//  Created by yanyu on 2019/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
