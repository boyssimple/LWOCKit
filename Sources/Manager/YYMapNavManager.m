//
//  YYMapNavManager.m
//  WisdomHotelCuster
//
//  Created by yanyu on 2019/10/16.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import "YYMapNavManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <LWOCKit/MBProgressHUD+YY.h>

@interface YYMapNavManager()<UIActionSheetDelegate>
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)UIView *view;
@end
@implementation YYMapNavManager

static YYMapNavManager *_shareInfo;

+(YYMapNavManager *)shareInstance
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _shareInfo = [[YYMapNavManager alloc]init];
    });
    return _shareInfo;
}


- (void)gotoAddress:(NSString*)address withView:(UIView*)view{
    _address = address;
    _view = view;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"高德地图",@"百度地图",@"腾讯地图",@"苹果地图", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!self.address) {
        return;
    }
    if (buttonIndex == 0) {
        //高德地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0",@"我的位置",[self.data jk_floatForKey:@"lat"],[self.data jk_floatForKey:@"lng"],@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dname=%@&dev=0&m=0&t=0",@"我的位置",self.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *r = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:r];
        }else{
            [MBProgressHUD showError:@"未安装高德地图" toView:nil timeDelay:1.2 finishBlock:^{
                
            }];
        }
    }else if(buttonIndex == 1){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
            NSString *baiduParameterFormat = @"baidumap://map/direction?origin=我的位置&destination=%@&mode=driving";
            NSString *urlString = [[NSString stringWithFormat:
                                    baiduParameterFormat,self.address]
                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [MBProgressHUD showError:@"未安装百度地图" toView:nil timeDelay:1.2 finishBlock:^{
                
            }];
        }
        
    }else if(buttonIndex == 2){
        //腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&to=%@&coord_type=1&policy=0",self.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *r = [NSURL URLWithString:urlString];
            
            [[UIApplication sharedApplication] openURL:r];
        }else{
            [MBProgressHUD showError:@"未安装腾讯地图" toView:nil timeDelay:1.2 finishBlock:^{
                
            }];
        }
    }else if(buttonIndex == 3){
        NSString *urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@",self.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

    }
}
@end
