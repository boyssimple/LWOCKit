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
        
        
二   、网络框架封装   
  第一步 AppDelegate中设置全局域名
   [YYNetworkingConfig shareInstance].hostUrl = @"http://xxxx.xsx.com";
   
  第二步 请求Model创建 ReqNewsModel (必须Req开头，Model结尾)，继承YYApiObject
  
  //请求地址
- (NSString*)apiUrl;

//请求方法默认POST (POST、GET)
- (NSString*)method;

//是否缓存（默认不缓存）
- (BOOL)isCache;

//是否显示Hud
- (BOOL)isShowHud;

//加载提示信息
- (NSString*)hudTips;

//缓存数据表扩展名
- (NSString*)getTableNameExt;

/** 结合接口名称生成单次请求(表中单条数据)的唯一key  默认@""*/
- (NSString*)getItemIDExt;

apiUrl设置url地址、isCache默认不缓存，如果缓存，下次会先加载本地缓存数据，再去请求网络数据返回

三、宏定义

//屏幕宽高
#define DEVICEWIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICEHEIGHT [UIScreen mainScreen].bounds.size.height

#define CURRENT_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define STATUS_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define NAV_STATUS_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define TABBAR_HEIGHT ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
#define NAV_HEIGHT 44.0
  
  
