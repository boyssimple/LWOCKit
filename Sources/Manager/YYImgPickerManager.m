//
//  YYImgPickerManager.m
//  DiagnosisOnlineDoctor
//
//  Created by yanyu on 2019/7/12.
//  Copyright © 2019 yanyu. All rights reserved.
//

#import "YYImgPickerManager.h"
@interface YYImgPickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@end
@implementation YYImgPickerManager

- (void)showActionWithVC:(UIViewController*)vc withBlock:(void(^)(UIImage *image))block{
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
    [vc presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - UIActionSheetDelegate
- (void)albumSelectphoto{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持相册");
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.currentVC presentViewController:self.pickerController animated:TRUE completion:nil];
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
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.currentVC presentViewController:self.pickerController animated:YES completion:nil];
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


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"%s,info == %@",__func__,info);
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.clickBlockAction) {
        self.clickBlockAction(image);
    }
    [self.pickerController dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%@",picker);
    [self.pickerController dismissViewControllerAnimated:TRUE completion:nil];
}


- (UIImagePickerController *)pickerController{
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc]init];
        _pickerController.delegate = self;
        _pickerController.allowsEditing = self.isAllowEdit;
    }
    return _pickerController;
}
@end
