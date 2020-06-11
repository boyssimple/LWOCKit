//
//  SQLocationManager.m
//  Audio
//
//  Created by luowei on 2020/6/11.
//  Copyright © 2020 luowei. All rights reserved.
//

#import "SQLocationManager.h"

@interface SQLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SQLocationFinishedBlock completion;
@end

@implementation SQLocationManager

+ (instancetype)share{
    static SQLocationManager *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)startLocationFinishedBlock:(SQLocationFinishedBlock)completion{
    _completion = completion;
    if (!_locationManager) {
        
        // 初始化定位管理器
        _locationManager = [[CLLocationManager alloc] init];
        // 设置代理
        _locationManager.delegate = self;
        // 设置定位精确度到米
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        // 取得定位权限，有两个方法，取决于你的定位使用情况
        // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
        // 这句话ios8以上版本使用。
        [_locationManager requestAlwaysAuthorization];
        // 开始定位
        [_locationManager startUpdatingLocation];
    }else{
        _locationManager.delegate = self;
        // 这句话ios8以上版本使用。
        [_locationManager requestAlwaysAuthorization];
        // 开始定位
        [_locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    manager.delegate = nil;
    CLLocation *lastLocation = [locations lastObject];
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    //根据经纬度获取省份城市
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:lastLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSString *province = placeMark.administrativeArea;//省
            NSString *city = placeMark.locality;//市
            NSString *area = placeMark.subLocality;//区
            NSString *street = placeMark.thoroughfare;//街道
            NSString *address = [NSString stringWithFormat:@"%@==%@==%@==%@",province==NULL?city:province,city,area,street];
            NSLog(@"定位成功：%@", address);
             if (self.completion) {
                 weakSelf.completion(SQLocationStateSuccess, lastLocation.coordinate.latitude, lastLocation.coordinate.longitude, province, city, area, street);
             }
        }

    }];
}


// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@----%ld",error,(long)[error code]);
    if ([error code] == 1) {
        //没有位置访问权限
        NSLog(@"没有权限");
        if (self.completion) {
            self.completion(SQLocationStateDenied, 0, 0, nil, nil, nil, nil);
        }
    }else{
        NSLog(@"定位失败");
        if (self.completion) {
            self.completion(SQLocationStateFail, 0, 0, nil, nil, nil, nil);
        }
    }
}
@end
