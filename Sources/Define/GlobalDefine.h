//
//  GlobalDefine.h
//  Project
//
//  Created by luowei on 2018/11/14.
//  Copyright © 2018年 luowei. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

//屏幕宽高
#define DEVICEWIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICEHEIGHT [UIScreen mainScreen].bounds.size.height


#define CURRENT_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//基本组件高度
#define IS_IPHONE_X ((DEVICEHEIGHT == 812.0f) ? YES : NO)
#define STATUS_HEIGHT  ((IS_IPHONE_X==YES)?44.0f: 20.0f)        //状态栏高度
#define NAV_STATUS_HEIGHT ((IS_IPHONE_X==YES)?88.0f: 64.0f)       //导航+状态栏高度
#define NAV_HEIGHT 44.0f      //导航
#define TABBAR_HEIGHT ((IS_IPHONE_X==YES)?83.0f: 49.0f)          //Tabbar高度

//宽比
#define RATIO_WIDHT750 [UIScreen mainScreen].bounds.size.width/375.0
#define RATIO_HEIGHT750 ([UIScreen mainScreen].bounds.size.height - NAV_STATUS_HEIGHT - TABBAR_HEIGHT)/(667.0-64-49)

//颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)
#define RGB3(v) RGB(v,v,v)
#define RandomColor RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
// rgb颜色转换（16进制->10进制）
#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

//重定义系统宏
#define NSLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );

//国际化
#define NSLocString(key,comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#endif /* GlobalDefine_h */
