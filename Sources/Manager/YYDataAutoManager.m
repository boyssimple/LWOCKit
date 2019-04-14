//
//  YYDataAutoManager.m
//  AFNetworking
//
//  Created by luowei on 2019/4/14.
//


#import "YYDataAutoManager.h"

@interface YYDataAutoManager()
@property (nonatomic, strong) YYDataManageEntity *entity;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation YYDataAutoManager

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
    if (self.numberOfSectionsInTableViewBlock) {
        return self.numberOfSectionsInTableViewBlock(tableView,self.entity);
    }
    return self.dataSource.count > 0 ? self.dataSource.count : self.entity.tableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.numberOfRowsInSectionBlock) {
        return self.numberOfRowsInSectionBlock(section);
    }else{
        return 1;
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
    UIView *header = nil;
    if (self.entity.headerView) {
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
        if (!header) {
            header = [[NSClassFromString(self.entity.headerView) alloc] initWithFrame:CGRectZero];
        }
        if (self.viewForHeaderInSectionBlock) {
            self.viewForHeaderInSectionBlock(header, self.entity, section);
        }
    }else{
        if(self.viewForHeaderInSectionReturnBlock){
            header = self.viewForHeaderInSectionReturnBlock(tableView,self.entity,section);
        }
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSectionBlock) {
        return self.heightForFooterInSectionBlock(tableView, self.entity, section);
    }else{
        return self.entity.cellFooterHeight ? : 0.00001f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = nil;
    if (self.entity.footerView) {
        footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Footer"];
        if (!footer) {
            footer = [[NSClassFromString(self.entity.footerView) alloc] initWithFrame:CGRectZero];
        }
        if (self.viewForFooterInSectionBlock) {
            self.viewForFooterInSectionBlock(footer, self.entity, section);
        }
    }else{
        if(self.viewForHeaderInSectionReturnBlock){
            footer = self.viewForHeaderInSectionReturnBlock(tableView,self.entity,section);
        }
    }
    return footer;
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

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.entity.indexs;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.entity.indexs objectAtIndex:section];;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSInteger count = 0;
    
    for (NSString *character in self.entity.indexs) {
        
        if ([[character uppercaseString] hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    return  0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}

@end
