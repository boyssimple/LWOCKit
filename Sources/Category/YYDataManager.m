//
//  YYDataManager.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYDataManager.h"

@interface YYDataManager()
@property (nonatomic, strong) YYDataManageEntity *entity;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation YYDataManager

- (void)addDataSourceManagerEntity:(YYDataManageEntity*)entity withTableView:(UITableView*)tableView{
    self.entity = entity;
    if (self.dataSource.count == 0) {
        for (NSString *identifier in entity.identifiers) {
            [tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
        }
    }
    self.dataSource = entity.dataSource;
    if ([self.delegate respondsToSelector:@selector(refreshDataWithTable:)]) {
        [self.delegate refreshDataWithTable:tableView];
    }
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
}

#pragma  mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count > 0 ? self.dataSource.count : self.entity.tableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.numberOfRowsInSectionBlock) {
        return self.numberOfRowsInSectionBlock(section);
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.heightForRowAtIndexPathBlock) {
        return self.heightForRowAtIndexPathBlock(indexPath);
    }else{
        if (self.entity.identifiers.count > 0) {
            return [NSClassFromString(self.entity.identifiers.firstObject) calHeight];
        }
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellForRowAtIndexPathBlock) {
        return self.cellForRowAtIndexPathBlock(tableView, self.entity, indexPath);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.heightForHeaderInSectionBlock) {
        return self.heightForHeaderInSectionBlock(tableView, self.entity, section);
    }else{
        return self.entity.cellHeaderHeight ? : 0.00001f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.entity.headerView) {
        UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        if(!header){
            header = [[NSClassFromString(self.entity.headerView) alloc]init];
        }
        if (self.viewForHeaderInSectionBlock) {
            self.viewForHeaderInSectionBlock(header, self.entity, section);
        }
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSectionBlock) {
        return self.heightForFooterInSectionBlock(tableView, self.entity, section);
    }else{
        return self.entity.cellFooterHeight ? : 0.00001f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.entity.footerView) {
        UIView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        if(!footer){
            footer = [[NSClassFromString(self.entity.footerView) alloc]init];
        }
        if (self.viewForFooterInSectionBlock) {
            self.viewForFooterInSectionBlock(footer, self.entity, section);
        }
        return footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectRowAtIndexPathBlock) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.didSelectRowAtIndexPathBlock(cell, self.entity, indexPath);
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canEditRowAtIndexPathBlock) {
        return self.canEditRowAtIndexPathBlock(tableView,self.entity,indexPath);
    }
    return self.entity.canEdit;
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.editActionsForRowAtIndexPathBlock) {
        return self.editActionsForRowAtIndexPathBlock(tableView,self.entity,indexPath);
    }
    if (self.entity.canEdit) {
        __weak typeof(self) weakSelf = self;
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            if (weakSelf.deleteActionForRowAtIndexPathBlock) {
                weakSelf.deleteActionForRowAtIndexPathBlock(tableView, self.entity, indexPath);
            }
        }];
        
        return @[deleteAction];
    }
    return @[];
}

@end

@implementation YYDataManageEntity
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
