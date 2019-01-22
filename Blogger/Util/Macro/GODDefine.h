//
//  GODDefine.h
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#ifndef GODDefine_h
#define GODDefine_h

#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//系统版本
#define iOSVerson                         [[UIDevice currentDevice] systemVersion].floatValue

// 宽度
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

// 状态栏高度
#define  StatusBarHeight                   [UIApplication sharedApplication].statusBarFrame.size.height//20.f

// 导航栏高度
#define  NavigationBarHeight               self.navigationController.navigationBar.frame.size.height//44.f

// 标签栏高度
#define  TabbarHeight                      self.tabBarController.tabBar.frame.size.height//49.f

// 状态栏高度 + 导航栏高度
#define  StatusBarAndNavigationBarHeight   (StatusBarHeight + NavigationBarHeight)//(20.f + 44.f)

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define GODColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]


/** 底部安全距离高度[适配PhoneX底部] */
#define SafeAreaBottomHeight (Height >= 812.0 ? 34 : 0)
/** 顶部安全距离高度[适配PhoneX底部] */
#define SafeAreaTopHeight (Height >= 812.0 ? 24 : 0)

#define SafeTabBarHeight (CGFloat)(Height >= 812.0?(49.0 + 34.0):(49.0))


// 安全执行Block
#define SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })


#endif /* GODDefine_h */
