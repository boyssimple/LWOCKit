//
//  UITextView+PlaceHolder.h
//
//
//  Created by simple on 2018/8/13.
//  Copyright © 2019年 luowei. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)

@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) UIColor *placeHolderColor;
//@property (nonatomic, strong) UIFont *font;
//当设置placeHolder是，请使用updateFont设置字体大小
- (void)updateFont:(UIFont *)font;
//当设置placeHolder是，请使用updateText设置值
-(void)updateText:(NSString *)text;
//当设置placeHolder是，请最后调用以便设置高度
- (void)updatePlaceHeights:(CGFloat)maxWights;
@end
