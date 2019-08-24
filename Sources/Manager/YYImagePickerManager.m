//
//  YYImagePickerManager.m
//  Project
//
//  Created by luowei on 2018/12/4.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYImagePickerManager.h"
#import <LWOCKit/GlobalDefine.h>
#import <LWOCKit/UIActionSheet+Blocks.h>

@interface YYImagePickerManager()
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation YYImagePickerManager

- (void)showActionWithVC:(UIViewController*)vc withBlock:(void(^)(YYImagePickerType actionType))block{
    self.clickBlockAction = block;
    self.currentVC = vc;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self albumSelectphoto];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cameraShootingphoto];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [alertController addAction:cameraAction];
    if (isPad) {
        [UIActionSheet showInView:vc.view
                        withTitle:nil
                cancelButtonTitle:nil
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"相册",@"相机",@"取消"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){ buttonTitleAtIndex:buttonIndex], (long)buttonIndex);
                             if (buttonIndex == 0) {
                                 [self albumSelectphoto];
                             }else if(buttonIndex == 1){
                                 [self cameraShootingphoto];
                             }
                         }];
    }else{
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)albumSelectphoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持相册");
        if (self.clickBlockAction) {
            self.clickBlockAction(YYImagePickerTypePhotosAlbum);
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-->隐私-->照片，中开启本应用的相机访问权限！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:knowAction];
        [self.currentVC presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cameraShootingphoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
        if (self.clickBlockAction) {
            self.clickBlockAction(YYImagePickerTypeCamera);
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置-->隐私-->相机，中开启本应用的相机访问权限！！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:knowAction];
        [self.currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
@end
