//
//  UITypes+extionsion.m
//  Project
//
//  Created by luowei on 2018/5/22.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "UITypes+extionsion.h"
#import <objc/runtime.h>

@implementation UIViewController (extension)

- (NSDictionary*)extData{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setExtData:(NSDictionary *)extData{
    objc_setAssociatedObject(self, @selector(extData), extData, OBJC_ASSOCIATION_RETAIN);
}


- (void)setLeftBackButton:(void (^)(void))calculateBlock{
    self.calculateBlock =  calculateBlock;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackAction)];
    self.navigationItem.leftBarButtonItem.imageInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self; // 让其能够侧滑返回上一层VC
    // 修改标题色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)clickBackAction{
    if(self.calculateBlock){
        self.calculateBlock();
    }
}

- (void)setCalculateBlock:(void (^)(void))calculateBlock{
    objc_setAssociatedObject(self, @"calculateBlock", calculateBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(void)) calculateBlock{
    return (id)objc_getAssociatedObject(self, @"calculateBlock");
}
@end


@implementation UIView (extension)

-(UINavigationController *)navigationController
{
    return [self viewController].navigationController;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews{
    NSArray *subs = [self subviews];
    for (UIView *v in subs) {
        [v removeFromSuperview];
    }
}

- (void)updateData{
    
}


- (void)updateData:(NSDictionary*)data{
    
}

+ (CGFloat)calHeight{
    return 0;
}

+ (CGFloat)calHeight:(NSDictionary*)data{
    return 0;
}
@end


@implementation UITableView (extension)

- (void)setYyDelegate:(id)yyDelegate{
    objc_setAssociatedObject(self, @selector(yyDelegate), yyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dataSource = yyDelegate;
    self.delegate = yyDelegate;
}

- (id)yyDelegate{
    return [objc_getAssociatedObject(self, _cmd) yyDelegate];
}

@end

@implementation UITableViewCell (extension)


@end

@implementation UICollectionView (extension)

- (void)setYyDelegate:(id)yyDelegate{
    objc_setAssociatedObject(self, @selector(yyDelegate), yyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dataSource = yyDelegate;
    self.delegate = yyDelegate;
}

- (id)yyDelegate{
    return [objc_getAssociatedObject(self, _cmd) yyDelegate];
}

@end

@implementation UIPageViewController (extension)

- (void)setYyDelegate:(id)yyDelegate{
    objc_setAssociatedObject(self, @selector(yyDelegate), yyDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dataSource = yyDelegate;
    self.delegate = yyDelegate;
}

- (id)yyDelegate{
    return [objc_getAssociatedObject(self, _cmd) yyDelegate];
}

@end


@implementation NSMutableArray (extension)

- (NSString*)parseToJSON{
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:self])
        
    {
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"json data:%@",jsonString);
        
        if(error) {
            
            NSLog(@"Error:%@", error);
            
        }
        
    }
    
    return jsonString;
}

@end

@implementation NSObject (extension)

- (NSString*)parseToJSON{
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:self])
        
    {
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"json data:%@",jsonString);
        
        if(error) {
            
            NSLog(@"Error:%@", error);
            
        }
        
    }
    
    return jsonString;
}



-(NSString *)convertToJsonData
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

- (NSDictionary*)parseToNSDictionary{
    NSDictionary *dic;
    if([self isKindOfClass:[NSString class]]){
        NSData *jsonData = [(NSString*)self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
        if(error){
            return nil;
        }
    }
    
    return dic;
}
- (NSArray*)parseToNSArray{
    NSMutableArray *array = [NSMutableArray array];
    if([self isKindOfClass:[NSString class]])
    {
        NSError *error;
        
        NSData *jsonData = [(NSString*)self dataUsingEncoding:NSUTF8StringEncoding];
        array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"json data:%@",jsonString);
        
        if(error) {
            NSLog(@"Error:%@", error);
        }
    }
    return array;
}
@end


@implementation UIImageView (extension)

- (BOOL)isAutoFill {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setIsAutoFill:(BOOL)isAutoFill{
    objc_setAssociatedObject(self, @selector(isAutoFill), @(isAutoFill), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isAutoFill) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = TRUE;
    }else{
        self.contentMode = UIViewContentModeScaleToFill;
        self.clipsToBounds = FALSE;
    }
}


@end

@implementation UIImage (extension)


// 生成二维码
+ (UIImage *)createImageWithString:(NSString *)string withSize:(CGFloat)size{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性（因为滤镜可能保存上一次的属性）
    [filter setDefaults];
    
    // 3.讲字符串转换为NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.通过了滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6.因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    UIImage *image = [self getErWeiMaImageFormCIImage:outputImage withSize:size];
    
    return image;
}

// 获取高清二维码图片
+ (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (NSString*)parseToBase64:(CGFloat)compression{
    compression = compression < 0.8f?0.8f:compression;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);//NSDataBase64EncodingEndLineWithLineFeed这个枚举值是base64串不换行
    NSString *imageBase64Str = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return imageBase64Str;
}
@end

@implementation UITextView (extension)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 8.0) {
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        placeHolderLabel.text = placeholdStr;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = placeholdColor;
        placeHolderLabel.font = self.font;
        [placeHolderLabel sizeToFit];
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}



@end

@implementation UILabel (extension)


- (void)setIsHtml:(BOOL)isHtml{
    objc_setAssociatedObject(self, @"isHtml", @(isHtml), OBJC_ASSOCIATION_RETAIN);
    if(isHtml && self.text.length > 0){
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.attributedText = attrStr;
    }
}

- (BOOL)isHtml{
    return (BOOL)objc_getAssociatedObject(self, @"isHtml");
}



/**
 设置中画线
 */
- (void)setCenterLine{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:attribtDic];
    self.attributedText = attribtStr;
}


/**
 设置行距
 
 @param value 行距值
 */
- (void)setLineSpace:(CGFloat)value{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:value];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    [self setAttributedText:attributedString];
}

@end


@implementation NSDate (extension)

/**
 格式化日期
 
 @param style 格式
 @return 返回格式化后字符串
 */
- (NSString*)formterToStr:(NSString*)style{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    return [dateFormatter stringFromDate:self];
}

@end

@implementation NSString (extension)

- (NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)parseDateStringFrom:(NSString*)fromStyle to:(NSString*)toStyle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromStyle];
    NSDate *date = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:toStyle];
    return [dateFormatter stringFromDate:date];
}

- (NSString*)parseDateString:(NSString*)formatterStyle{
    return [self parseDateStringFrom:@"yyyy-MM-dd HH:mm:ss" to:formatterStyle];
}

+ (NSString *)timeStampConverTime:(NSTimeInterval)timeStamp toStyle:(NSString *)style{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    NSDate *recevieDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString *newTimeStr = [dateFormatter stringFromDate:recevieDate];
    return newTimeStr;
}
+ (NSString*)timeStampConverTimeWithStr:(NSString*)timeStamp toStyle:(NSString *)style{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    return [date formterToStr:style];
}

+ (NSString *)htmlEntityDecode: (NSString *)str{
    
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\n"];
    return str;
}



/**
 指定格式字符串转日期
 
 @param formStyle 格式(例如:2018-11-14 17:49:11)
 @return 返回日期
 */
- (NSDate*)parseToDate:(NSString*)formStyle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formStyle];
    return [dateFormatter dateFromString:self];
}

/**
 base64 转Image
 
 @return 返回UIIMage
 */
- (UIImage *)base64ParseToImage{
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
@end

@implementation NSMutableDictionary (extension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        Method original = class_getInstanceMethod(class, @selector(setObject:forKey:));
        Method replace = class_getInstanceMethod(class, @selector(swiz_setObject:forKey:));
        method_exchangeImplementations(original, replace);
    });
}

- (void)swiz_setObject:(id)anObject forKey:(id)aKey{
    if (!anObject) {
        anObject = @"";
    }
    if(!aKey){
        aKey = @"";
    }
    [self swiz_setObject:anObject forKey:aKey];
}
@end



@implementation UIButton (extension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(sendAction:to:forEvent:);
        SEL swizzSel = @selector(xy_sendAction:to:forEvent:);
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

- (void)setIsUsedLogin:(BOOL)isUsedLogin{
    objc_setAssociatedObject(self, @"isUsedLogin", @(isUsedLogin), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isUsedLogin{
    return (BOOL)objc_getAssociatedObject(self, @"isUsedLogin");
}


- (void)xy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if(self.isUsedLogin){
        NSLog(@"需要登录");
        [self xy_sendAction:action to:target forEvent:event];
    }else{
        NSLog(@"无需登录");
        [self xy_sendAction:action to:target forEvent:event];
    }
    
    
}


@end

@implementation UIColor (extension)
- (UIImage *)parseToImage{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
