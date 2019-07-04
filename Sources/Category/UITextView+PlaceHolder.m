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

- (NSString *)placeHolder
{
    return objc_getAssociatedObject(self, textView_key);
}


- (void)setFont:(UIFont *)font{
    if (font != self.font) {
        objc_setAssociatedObject(self, textView_Font_key, font, OBJC_ASSOCIATION_COPY_NONATOMIC);
        UILabel *lb = [self viewWithTag:10000];
        if (lb) {
            lb.font = font;
        }
    }
}

- (UIFont *)font{
    return objc_getAssociatedObject(self, textView_Font_key);
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
