//
//  UITextField+YY.m
//  Project
//
//  Created by luowei on 2018/11/23.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "UITextField+YY.h"
#import <objc/runtime.h>

@implementation UITextField (YY)

+ (void)load{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initwithFrame
        SEL systemSel = @selector(initWithFrame:);
        SEL swizzSel = @selector(swiz_initWithFrame:);
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.lentgh > 0) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= self.lentgh;
    }
    return TRUE;
}

- (instancetype)swiz_initWithFrame:(CGRect)frame{
    self.delegate =  self;
    
    [self addTarget:self action:@selector(tfTextAction:) forControlEvents:UIControlEventEditingChanged];
    return [self swiz_initWithFrame:frame];
}


- (void)tfTextAction:(UITextField*)textField{
    if (textField.markedTextRange == nil) {
        self.isValidate = FALSE;
        if (self.inputType == UITextfieldInputTypeAccount) {
            
        }else if(self.inputType == UITextfieldInputTypePassword){
            
        }else if(self.inputType == UITextfieldInputTypePhone){
            if ([self validateContactNumber:self.text]) {
                self.isValidate = TRUE;
            }
        }else if(self.inputType == UITextfieldInputTypeIDCard){
            if ([self validateIdentityCard:self.text]) {
                self.isValidate = TRUE;
            }
        }else if(self.inputType == UITextfieldInputTypeEmail){
            if ([self validateEmail:self.text]) {
                self.isValidate = TRUE;
            }
        }else if(self.inputType == UITextfieldInputTypeCode){
            if ([self validateVerifyCode:self.text]) {
                self.isValidate = TRUE;
            }
        }
        //        if (!self.isValidate) {
        //            self.layer.borderColor = [UIColor redColor].CGColor;
        //            self.layer.borderWidth = 1;
        //        }else{
        //            self.layer.borderColor = [UIColor grayColor].CGColor;
        //            self.layer.borderWidth = 1;
        //        }
    }
}

- (void)setInputType:(UITextfieldInputType)inputType{
    if (inputType == UITextfieldInputTypeAccount) {
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.placeholder = @"请输入帐号";
    }else if(inputType == UITextfieldInputTypePassword){
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.placeholder = @"请输入密码";
    }else if(inputType == UITextfieldInputTypePhone){
        self.keyboardType = UIKeyboardTypePhonePad;
        self.placeholder = @"请输入手机号码";
    }else if(inputType == UITextfieldInputTypeIDCard){
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.placeholder = @"请输入身份证号码";
    }else if(inputType == UITextfieldInputTypeEmail){
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.placeholder = @"请输入邮箱";
    }else if(inputType == UITextfieldInputTypeCode){
        self.keyboardType = UIKeyboardTypePhonePad;
        self.placeholder = @"请输入验证码";
    }else if(inputType == UITextfieldInputTypeNumber){
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    /*
     UIKeyboardTypeDefault,                // Default type for the current input method.
     UIKeyboardTypeASCIICapable,           // Displays a keyboard which can enter ASCII characters
     UIKeyboardTypeNumbersAndPunctuation,  // Numbers and assorted punctuation.
     UIKeyboardTypeURL,                    // A type optimized for URL entry (shows . / .com prominently).
     UIKeyboardTypeNumberPad,              // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
     UIKeyboardTypePhonePad,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
     UIKeyboardTypeNamePhonePad,           // A type optimized for entering a person's name or phone number.
     UIKeyboardTypeEmailAddress,
     
     UITextfieldInputTypeAccount = 1 << 0,                   //帐号
     UITextfieldInputTypePassword = 1 << 1,                  //密码
     UITextfieldInputTypePhone = 1 << 2,                     //手机号码
     UITextfieldInputTypeIDCard = 1 << 3,                    //身份证
     UITextfieldInputTypeCode = 1 << 4,                      //验证码
     UITextfieldInputTypeNumber = 1 << 5,                    //数字
     UITextfieldInputTypeChinese = 1 << 6,                   //汉字
     UITextfieldInputTypeCharacter = 1 << 7,                 //字母 小写
     UITextfieldInputTypeEmail = 1 << 8,            //字母 大写
     UITextfieldInputTypeCharacterUpper = 1 << 9,            //字母 大写
     objc_setAssociatedObject(self, @"inputType", @(inputType), OBJC_ASSOCIATION_RETAIN);
     */
    objc_setAssociatedObject(self, @selector(inputType), @(inputType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITextfieldInputType)inputType{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setIsValidate:(BOOL)isValidate{
    objc_setAssociatedObject(self, @selector(isValidate), @(isValidate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isValidate{
    BOOL validate = [objc_getAssociatedObject(self, _cmd) boolValue];
    if (self.inputType == UITextfieldInputTypeAccount) {
        
    }else if(self.inputType == UITextfieldInputTypePassword){
        
    }else if(self.inputType == UITextfieldInputTypePhone){
        if ([self validateContactNumber:self.text]) {
            validate = TRUE;
        }
    }else if(self.inputType == UITextfieldInputTypeIDCard){
        if ([self validateIdentityCard:self.text]) {
            validate = TRUE;
        }
    }else if(self.inputType == UITextfieldInputTypeEmail){
        if ([self validateEmail:self.text]) {
            validate = TRUE;
        }
    }else if(self.inputType == UITextfieldInputTypeCode){
        if ([self validateVerifyCode:self.text]) {
            validate = TRUE;
        }
    }
    return validate;
}

- (void)setLentgh:(NSInteger)lentgh{
    objc_setAssociatedObject(self, @selector(lentgh), @(lentgh), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lentgh{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

#pragma mark - 方法

- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)validateIdentityCard:(NSString *)identityCard
{
    if (identityCard.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}


/**
 验证码
 
 @param verifyCode 字符串
 @return 是否通过
 */
- (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!(verifyCode.length == 6)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

- (BOOL)validateContactNumber:(NSString *)mobileNum{

    NSString * MOBILE = @"^1\d{10}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}
@end
