//
//  UIButton+Custom.h
//  Project
//
//  Created by luowei on 16/8/18.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (Custom)
/**
 *  Button 设置图片在上文字在下
 */
+(void)editImgAndTitleWithBtn:(UIButton*)btn;
+(void)editImgAndTitleWithBtn:(UIButton*)btn andF:(float)theF;
+(void)editImgAndTitleChangeWithBtn:(UIButton*)btn;
/** 按钮标题右偏移 */
+(void)editTitleWithBtnRight:(UIButton *)btn andF:(float)theF;
/** 按钮标题下偏移 */
+(void)editTitleWithBtnDown:(UIButton *)btn andF:(float)theF;

@end
