//
//  UITypes+extionsion.h
//  Project
//
//  Created by luowei on 2018/5/22.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (extension)
@property (strong,nonatomic)NSDictionary *extData;

@property (nonatomic, strong) void (^calculateBlock)(void);
- (void)setLeftBackButton:(void(^)(void))calculateBlock;
@end

@interface UIView (extension)

- (UINavigationController *)navigationController;

- (void)updateData;

- (void)updateData:(NSDictionary*)data;

- (void)updateDataWithModel:(id)model;

- (void)removeAllSubviews;

+ (CGFloat)calHeight;

+ (CGFloat)calHeight:(NSDictionary*)data;

- (UIViewController *)viewController ;
@end

@interface UITableView (extension)
//代理
@property (nonatomic, weak, nullable) id yyDelegate;

@end

@interface UITableViewCell (extension)

@end

@interface UICollectionView (extension)
//代理
@property (nonatomic, weak, nullable) id yyDelegate;

@end

@interface UIPageViewController (extension)
//代理
@property (nonatomic, weak, nullable) id yyDelegate;

@end

@interface NSMutableArray (extension)
- (NSString*)parseToJSON;
@end

@interface NSObject (extension)
- (NSString*)parseToJSON;



-(NSString *)convertToJsonData;//去掉空格

- (NSDictionary*)parseToNSDictionary;
/** 字符串转数组 */
- (NSArray*)parseToNSArray;
@end

@interface UIImageView (extension)
@property(nonatomic,assign)BOOL isAutoFill;
@end

@interface UIImage (extension)

// 生成二维码
+ (UIImage *)createImageWithString:(NSString *)string withSize:(CGFloat)size;

- (NSString*)parseToBase64:(CGFloat)compression;
@end


@interface UITextView (extension)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;


@end

@interface UILabel (extension)
@property (nonatomic, assign) BOOL isHtml;//是否是html代码

/**
 设置中画线
 */
- (void)setCenterLine;

/**
 设置行距
 
 @param value 行距值
 */
- (void)setLineSpace:(CGFloat)value;
@end

@interface NSDate (extension)


/**
 格式化日期
 
 @param style 格式
 @return 返回格式化后字符串
 */
- (NSString*)formterToStr:(NSString*)style;

@end

@interface NSString (extension)

- (NSString*)trim;

//把原格式日期转传入的格式
- (NSString*)parseDateStringFrom:(NSString*)fromStyle to:(NSString*)toStyle;

//把标准yyyy-MM-dd HH:mm:ss 日期转传入的格式
- (NSString*)parseDateString:(NSString*)formatterStyle;

//时间戳转指定日期格式字符串
+ (NSString *)timeStampConverTime:(NSTimeInterval)timeStamp toStyle:(NSString *)style;
+ (NSString*)timeStampConverTimeWithStr:(NSString*)timeStamp toStyle:(NSString *)style;
//HTML5 转成字符串
+ (NSString *)htmlEntityDecode: (NSString *)str;

/**
 指定格式字符串转日期
 
 @param formStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回日期
 */
- (NSDate*)parseToDate:(NSString*)formStyle;


/**
 base64 转Image
 
 @return 返回UIIMage
 */
- (UIImage *)base64ParseToImage;
@end


@interface NSMutableDictionary (extension)

@end

#define SYSTEMISUSELOGINNOTIFICATION @"SYSTEMISUSELOGINNOTIFICATION"
#define USERLOGINFAILED @"USERLOGINFAILED"

@interface UIButton (extension)
@property (nonatomic, assign) BOOL isUsedLogin;//是否需要登录
@end

@interface UIColor (extension)
- (UIImage *)parseToImage;
@end
