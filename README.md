# LWOCKit
LWOCKit


LWOCKit框架包含了很多常用封装

一、UITableView 、UICollectionView 封装

第一步 定义tableView
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.backgroundColor = RGB3(247);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.yyDelegate = self.manager;
    }
    return _table;
}

第二步 manager定义


- (YYDataManager *)manager{
    if (!_manager) {
        _manager = [[YYDataManager alloc]init];
        _manager.delegate = self;
        __weak typeof(self) weakSelf = self;
        
        //cell数据处理
        _manager.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *table, YYDataManageEntity *entity, NSIndexPath *indexPath) {
            CellCategaryType *cell = (CellCategaryType*)[table dequeueReusableCellWithIdentifier:entity.identifiers.firstObject];
            return cell;
        };
        
        //点击cell
        _manager.didSelectRowAtIndexPathBlock = ^(UITableViewCell *cell, YYDataManageEntity *model, NSIndexPath *indexPath) {
            
        };
        
    }
    return _manager;
}

第三步  加载数据定义

YYDataManageEntity *entity = [[YYDataManageEntity alloc] init];
        entity.identifiers = @[@"CellCategaryType"];
        entity.tableSections = weakSelf.dataSource.count;
        [weakSelf.manager addDataSourceManagerEntity:entity withTableView:weakSelf.table];
        
        
二       
、网络框架封装       
        
