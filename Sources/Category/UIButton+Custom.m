//
//  UIButton+Custom.m
//  Project
//
//  Created by luowei on 16/8/18.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

+(void)editImgAndTitleWithBtn:(UIButton*)btn{
//    CGFloat totalHeight = (btn.imageView.height + btn.titleLabel.height);
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.height)-1, 0.0, 0.0, -btn.titleLabel.width)];
//    // 设置按钮标题偏移
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.width, -(totalHeight - btn.titleLabel.height)-1,0.0)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    
}



+(void)editImgAndTitleWithBtn:(UIButton*)btn andF:(float)theF{
//    CGFloat totalHeight = (btn.imageView.height + btn.titleLabel.height);
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.height)-theF, 0.0, 0.0, -btn.titleLabel.width)];
//    // 设置按钮标题偏移
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(theF, -btn.imageView.width, -(totalHeight - btn.titleLabel.height)-1,0.0)];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width, -btn.imageView.frame.size.height-theF/2, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height-theF/2, 0, 0, -btn.titleLabel.intrinsicContentSize.width);
    
}



//UIEdgeInsets insets = {top, left, bottom, right};
+(void)editImgAndTitleChangeWithBtn:(UIButton*)btn{
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width, 0, btn.imageView.image.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.frame.size.width, 0, - btn.titleLabel.frame.size.width);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width + btn.titleLabel.frame.size.width, 0, 0);
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.frame.size.width + btn.imageView.frame.size.width);
}

+(void)editTitleWithBtnRight:(UIButton *)btn andF:(float)theF
{
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, theF);

}
+(void)editTitleWithBtnDown:(UIButton *)btn andF:(float)theF
{
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, theF,0);
    
}

@end
