//
//  UITextView+PlaceHolder.m
//
//
//  Created by simple on 2018/8/13.
//  Copyright © 2019年 luowei. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
static const void *textView_key = @"placeHolder";
static const void *textView_Color_key = @"placeHolderColor";
static const void *textView_Font_key = @"placeHolderFont";

@interface UITextView ()
@end

@implementation UITextView (PlaceHolder)

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if (placeHolder != self.placeHolder) {
        objc_setAssociatedObject(self, textView_key, placeHolder, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        UILabel *lbPlace = [self viewWithTag:10000];
        if (lbPlace) {
            [lbPlace removeFromSuperview];
        }
        
        UILabel *placeHolderLb = [[UILabel alloc] initWithFrame:CGRectMake(2, 7, kScreenW-2*16, 21)];
        placeHolderLb.tag = 10000;
        placeHolderLb.contentMode = UIViewContentModeTop;
        placeHolderLb.numberOfLines = 0;
        placeHolderLb.textColor = self.placeHolderColor ? : [UIColor lightGrayColor];
        placeHolderLb.font = self.font;//[UIFont systemFontOfSize:16];
        placeHolderLb.alpha = 1;
        placeHolderLb.text = placeHolder;
        [self addSubview:placeHolderLb];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
}

- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (NSString *)placeHolder
{
    return objc_getAssociatedObject(self, textView_key);
}


//- (void)setFont:(UIFont *)font{
//    if (font != self.font) {
//        objc_setAssociatedObject(self, textView_Font_key, font, OBJC_ASSOCIATION_COPY_NONATOMIC);
//        UILabel *lb = [self viewWithTag:10000];
//        if (lb) {
//            lb.font = font;
//        }
//    }
//}
//
//- (UIFont *)font{
//    return objc_getAssociatedObject(self, textView_Font_key);
//}

//当设置placeHolder是，请使用updateFont设置字体大小
- (void)updateFont:(UIFont *)font{
    self.font = font;
    UILabel *lb = [self viewWithTag:10000];
    if (lb) {
        lb.font = font;
    }
}

//当设置placeHolder是，请最后调用以便设置高度
- (void)updatePlaceHeights:(CGFloat)maxWights{
    UILabel *lb = [self viewWithTag:10000];
    if (lb) {
        CGFloat placeHeights = [self getStringHeightWithText:self.placeHolder font:self.font viewWidth:maxWights];
        lb.frame = CGRectMake(2, 7, maxWights, placeHeights);
    }
}

//当设置placeHolder是，请使用updateText设置值
-(void)updateText:(NSString *)text {
    self.text = text;
    UILabel *lb = [self viewWithTag:10000];
    if (lb) {
        lb.hidden = text.length == 0 ? FALSE:TRUE;
    }
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    if (placeHolderColor != self.placeHolderColor) {
        objc_setAssociatedObject(self, textView_Color_key, placeHolderColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
        UILabel *lb = [self viewWithTag:10000];
        if (lb) {
            lb.textColor = placeHolderColor;
        }
    }
}

- (UIColor *)placeHolderColor{
    return objc_getAssociatedObject(self, textView_Color_key);
}

- (void)textViewChanged:(NSNotification *)noti
{
    UILabel *label = [self viewWithTag:10000];
    if (self.text.length == 0) {
        label.alpha = 1;
    } else {
        label.alpha = 0;
    }
}

@end
