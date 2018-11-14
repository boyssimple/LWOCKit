//
//  RegularJudgment.h
//  Project
//
//  Created by luowei on 2018/11/14.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegularJudgment : NSObject

/**
 *  验证邮箱
 *
 *  @param email 邮箱
 *
 *  @return YES/NO
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  验证手机号
 *
 *  @param mobile 手机号
 *
 *  @return YES/NO
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  验证车牌号
 *
 *  @param carNo 车牌号
 *
 *  @return YES/NO
 */
+ (BOOL)validateCarNo:(NSString *)carNo;

/**
 *  验证车型
 *
 *  @param CarType 车型
 *
 *  @return YES/NO
 */
+ (BOOL)validateCarType:(NSString *)CarType;

/**
 *  验证用户名
 *
 *  @param name 用户名
 *
 *  @return YES/NO
 */
+ (BOOL)validateUserName:(NSString *)name;

/**
 *  验证密码
 *
 *  @param passWord 密码
 *
 *  @return YES/NO
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 *  验证昵称
 *
 *  @param nickname 昵称
 *
 *  @return YES/NO
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  验证身份证
 *
 *  @param identityCard 身份证
 *
 *  @return YES/NO
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *  验证银行卡号
 *
 *  @param bankCardNumber 银行卡号
 *
 *  @return YES/NO
 */
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber;

/**
 *  验证银行卡后四位
 *
 *  @param bankCardNumber 银行卡后四位
 *
 *  @return YES/NO
 */
+ (BOOL)validateBankCardLastNumber:(NSString *)bankCardNumber;

/**
 *  验证CVN
 *
 *  @param cvnCode CVN
 *
 *  @return YES/NO
 */
+ (BOOL)validateCVNCode:(NSString *)cvnCode;

/**
 *  验证月份
 *
 *  @param month 月份
 *
 *  @return YES/NO
 */
+ (BOOL)validateMonth:(NSString *)month;

/**
 *  验证年
 *
 *  @param year 年
 *
 *  @return YES/NO
 */
+ (BOOL)validateYear:(NSString *)year;

/**
 *  验证验证码
 *
 *  @param verifyCode 验证码
 *
 *  @return YES/NO
 */
+ (BOOL)validateVerifyCode:(NSString *)verifyCode;

/**
 *  类方法自定义正则验证
 *
 *  @param customRegex  自定义的正则表达式
 *  @param targetString 目标字符串
 *
 *  @return YES/NO
 */
+ (BOOL)validateCustomRegex:(NSString *)customRegex TargetString:(NSString *)targetString;

/**
 *  验证身份证号码
 */
+(BOOL)checkUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END
