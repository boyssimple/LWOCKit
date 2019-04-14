//
//  UIButton.h
//  AFNetworking
//
//  Created by luowei on 2019/4/14.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, layoutTextWithImageButtonStyle) {
    LayoutTextUnderImageButton, // 图片在上 ， 文字在下
    layoutTextLeftImageButton,  // 文字在左 ， 图片在右
    layoutTextRightImageButton, // 文字在右 ， 图片在左
    layoutTextUpImageButton,  //图片在下，文字在上
};

@interface UIButton (ButtonStyle)

- (void)layoutTextWithImageButtonStyle:(layoutTextWithImageButtonStyle)style withSpace:(CGFloat)space;

@end
