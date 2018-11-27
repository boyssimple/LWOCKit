//
//  YYCollectionDataManager.m
//  Project
//
//  Created by luowei on 2018/11/26.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYCollectionDataManager.h"

@interface YYCollectionDataManager()
@property (nonatomic, strong) YYCollectionDataManageEntity *entity;
@property (nonatomic, strong) NSArray *dataSource;
@end
@implementation YYCollectionDataManager

- (void)addDataSourceManagerEntity:(YYCollectionDataManageEntity*)entity withTableView:(UICollectionView*)collectionView{
    self.entity = entity;
    if (self.dataSource.count == 0) {
        for (NSString *identifier in entity.identifiers) {
            [collectionView registerClass:NSClassFromString(identifier) forCellWithReuseIdentifier:identifier];
        }
        if (self.entity.headerView) {
            [collectionView registerClass:NSClassFromString(self.entity.headerView) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        }else{
            for (NSString *identifier in entity.headerViews) {
                [collectionView registerClass:NSClassFromString(identifier) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            }
        }
        if (self.entity.footerView) {
            [collectionView registerClass:NSClassFromString(self.entity.footerView) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
        }else{
            
            for (NSString *identifier in entity.footerViews) {
                [collectionView registerClass:NSClassFromString(identifier) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
            }
        }
    }
    self.dataSource = entity.dataSource;
    if ([self.delegate respondsToSelector:@selector(refreshDataWithCollection:)]) {
        [self.delegate refreshDataWithCollection:collectionView];
    }
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count > 0 ? self.dataSource.count : self.entity.tableSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.numberOfRowsInSectionBlock) {
        return self.numberOfRowsInSectionBlock(section);
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellForRowAtIndexPathBlock) {
        return self.cellForRowAtIndexPathBlock(collectionView, self.entity, indexPath);
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sizeForItemAtIndexPathBlock) {
        return self.sizeForItemAtIndexPathBlock(indexPath);
    }
    
    return CGSizeZero;
}

//Header

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.heightForHeaderInSectionBlock) {
        return self.heightForHeaderInSectionBlock(collectionView, self.entity, section);
    }else{
        return self.entity.cellHeaderSize;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.heightForFooterInSectionBlock) {
        return self.heightForFooterInSectionBlock(collectionView, self.entity, section);
    }else{
        return self.entity.cellFooterSize;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.entity.headerView) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
            if (self.viewForHeaderInSectionBlock) {
                self.viewForHeaderInSectionBlock(reusableView, self.entity, indexPath);
            }
        }else{
            if (self.viewForHeaderInSectionReturnBlock) {
                reusableView = self.viewForHeaderInSectionReturnBlock(collectionView,self.entity,indexPath);
            }
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (self.entity.footerView) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
            if (self.viewForFooterInSectionBlock) {
                self.viewForFooterInSectionBlock(reusableView, self.entity, indexPath);
            }
        }else{
            if (self.viewForFooterInSectionReturnBlock) {
                reusableView = self.viewForFooterInSectionReturnBlock(collectionView,self.entity,indexPath);
            }
        }
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectItemAtIndexPathBlock) {
        self.didSelectItemAtIndexPathBlock(collectionView,self.entity,indexPath);
    }
}

@end
@implementation YYCollectionDataManageEntity

@end
