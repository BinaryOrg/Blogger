//
//  GODLaunchManager.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODLaunchManager.h"
#import <MFHUDManager.h>
#import "UIColor+CustomColors.h"

#import "GODMainViewController.h"
#import "GODMusicViewController.h"
#import "GODPersonViewController.h"
#import "GODDynamicController.h"
@implementation GODLaunchManager
+ (instancetype)sharedInstance {
    static GODLaunchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)launchInWindow:(UIWindow *)window {
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor themeColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor themeColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    GODMainViewController *main = [[GODMainViewController alloc] init];
    GODMusicViewController *music = [[GODMusicViewController alloc] init];
    GODPersonViewController *person = [[GODPersonViewController alloc] init];
    GODDynamicController *dynamic = [[GODDynamicController alloc] init];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:main];
    UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:person];
    UINavigationController *musicNavi = [[UINavigationController alloc] initWithRootViewController:music];
    UINavigationController *dynamicNavi = [[UINavigationController alloc] initWithRootViewController:dynamic];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[
                                         mainNavi,
                                         musicNavi,
                                         dynamicNavi,
                                         personNavi
                                         ];
    window.rootViewController = tabBarController;
    
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
}
@end
