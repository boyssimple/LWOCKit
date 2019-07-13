//
//  YYVersionManager.m
//  DiagnosisOnlineDoctor
//
//  Created by yanyu on 2019/7/13.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import "YYVersionManager.h"

@interface YYVersionManager()
@property (nonatomic, strong) NSString *newsVersionStr;
@property (nonatomic, strong) NSString *appVersionStr;
@end
@implementation YYVersionManager

+ (instancetype)shared {
    static YYVersionManager *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[YYVersionManager alloc] init];
    });
    return client;
}


#pragma mark - 检查是否是最新版本
- (void)checkVersion{
    //获取当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.appVersionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //获取APP Store版本
    NSString *urlString = self.url;//@"https://itunes.apple.com/cn/lookup?id=1433884031"; //自己应用在App Store里的地址
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *innforDict = [jsonResponseString parseToNSDictionary];
        NSArray *array = [innforDict jk_arrayForKey:@"results"];
        NSString *notesStr = @"";
        for (NSDictionary *dict in array) {
            self.newsVersionStr = [dict jk_stringForKey:@"version"]; // appStore 的版本号
            notesStr = [dict jk_stringForKey:@"releaseNotes"];
        }
        
        if ([self compare:self.newsVersionStr]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"APP更新"
                                                                                     message:notesStr
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self updateVersion];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Cancel Action");
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.viewController presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

/**
 更新版本
 */
- (void)updateVersion{
    NSURL *cleanURL = [NSURL URLWithString:self.url];
    [[UIApplication sharedApplication] openURL:cleanURL];
}

- (BOOL)compare:(NSString*)serverVersion{
    NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    BOOL result = [appVersion compare:serverVersion] == NSOrderedAscending;
    return result;
}

@end
