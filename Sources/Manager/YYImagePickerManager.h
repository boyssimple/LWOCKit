//
//  YYImagePickerManager.h
//  Project
//
//  Created by luowei on 2018/12/4.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YYImagePickerType) {
    YYImagePickerTypePhotosAlbum,       //相册
    YYImagePickerTypeCamera             //相机
};

@interface YYImagePickerManager : NSObject
@property (nonatomic, strong) void (^clickBlockAction)(YYImagePickerType actionType);

- (void)showActionWithVC:(UIViewController*)vc withBlock:(void(^)(YYImagePickerType actionType))block;

@end

