//
//  UITextField+YY.h
//  Project
//
//  Created by luowei on 2018/11/23.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, UITextfieldInputType) {
    UITextfieldInputTypeAccount = 1 << 0,                   //帐号
    UITextfieldInputTypePassword = 1 << 1,                  //密码
    UITextfieldInputTypePhone = 1 << 2,                     //手机号码
    UITextfieldInputTypeIDCard = 1 << 3,                    //身份证
    UITextfieldInputTypeEmail = 1 << 4,                     //邮箱
    UITextfieldInputTypeCode = 1 << 5,                      //验证码
    UITextfieldInputTypeNumber = 1 << 6,                    //数字
    UITextfieldInputTypeChinese = 1 << 7,                   //汉字
    UITextfieldInputTypeCharacter = 1 << 8,                 //字母 小写
    UITextfieldInputTypeCharacterUpper = 1 << 9,            //字母 大写
    
    
};

@interface UITextField (YY)<UITextFieldDelegate>
@property (nonatomic, assign) UITextfieldInputType inputType;
@property (nonatomic, assign) BOOL isValidate;                  //是否通过验证
@property (nonatomic, assign) NSInteger lentgh;                 //限制长度
@end

