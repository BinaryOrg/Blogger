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
#import "GODPostController.h"


#import <XHLaunchAd.h>
#import "GODAdModel.h"

#import "GODWebViewController.h"
#import "GODSDKConfigKey.h"

#import <AVOSCloud/AVOSCloud.h>

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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:5];
    
    [MFNETWROK get:@"advertisement" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"%@", result);
        if (![result[@"code"] integerValue]) {
            GODAdModel *model = [GODAdModel yy_modelWithJSON:result];
            //配置广告数据
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            imageAdconfiguration.duration = 5;
            imageAdconfiguration.frame = [UIScreen mainScreen].bounds;
            imageAdconfiguration.imageNameOrURLString = [NSString stringWithFormat:@"%@%@",BASE_AVATAR_URL, model.urlString];
            imageAdconfiguration.GIFImageCycleOnce = NO;
            imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
            imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
            imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
            imageAdconfiguration.showFinishAnimateTime = 0.8;
            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            imageAdconfiguration.showEnterForeground = NO;
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        }else {
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
            imageAdconfiguration.imageNameOrURLString = @"ad.jpg";
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
        imageAdconfiguration.imageNameOrURLString = @"ad.jpg";
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    }];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Config"];
    [query orderByDescending:@"createdAt"];
    // owner 为 Pointer，指向 _User 表
    [query includeKey:@"type"];
    // image 为 File
    [query includeKey:@"urlString"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *testObject = objects.firstObject;
            NSInteger type = [[testObject objectForKey:@"type"] integerValue];
            NSString *urlString = [testObject objectForKey:@"urlString"];
            
            if (!type && urlString.length) {
                GODWebViewController *webController = [[GODWebViewController alloc] init];
                webController.urlString = urlString;
                UINavigationController *webNavi = [[UINavigationController alloc] initWithRootViewController:webController];
                window.rootViewController = webNavi;
                window.backgroundColor = [UIColor whiteColor];
                [window makeKeyAndVisible];
            }else {
                GODMainViewController *main = [[GODMainViewController alloc] init];
                GODMusicViewController *music = [[GODMusicViewController alloc] init];
                
                GODPostController *post = [[GODPostController alloc] init];
                
                GODPersonViewController *person = [[GODPersonViewController alloc] init];
                GODDynamicController *dynamic = [[GODDynamicController alloc] init];
                UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:main];
                UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:person];
                UINavigationController *postNavi = [[UINavigationController alloc] initWithRootViewController:post];

                UINavigationController *musicNavi = [[UINavigationController alloc] initWithRootViewController:music];
                UINavigationController *dynamicNavi = [[UINavigationController alloc] initWithRootViewController:dynamic];
                
                UITabBarController *tabBarController = [[UITabBarController alloc] init];
                tabBarController.viewControllers = @[
                                                     mainNavi,
                                                     musicNavi,
                                                     postNavi,
                                                     dynamicNavi,
                                                     personNavi
                                                     ];
                window.rootViewController = tabBarController;
                
                window.backgroundColor = [UIColor whiteColor];
                [window makeKeyAndVisible];
            }
        }
    }];
    
   
    
//
//
//
//    [MFNETWROK get:@"launch" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
//        NSLog(@"%@", result);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![result[@"code"] integerValue]) {
//
//                if (![result[@"type"] integerValue]) {
//                    GODWebViewController *webController = [[GODWebViewController alloc] init];
//                    webController.urlString = result[@"urlString"];
//                    UINavigationController *webNavi = [[UINavigationController alloc] initWithRootViewController:webController];
//                    window.rootViewController = webNavi;
//                    window.backgroundColor = [UIColor whiteColor];
//                    [window makeKeyAndVisible];
//                }else {
//                    GODMainViewController *main = [[GODMainViewController alloc] init];
//                    GODMusicViewController *music = [[GODMusicViewController alloc] init];
//                    GODPersonViewController *person = [[GODPersonViewController alloc] init];
//                    GODDynamicController *dynamic = [[GODDynamicController alloc] init];
//                    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:main];
//                    UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:person];
//                    UINavigationController *musicNavi = [[UINavigationController alloc] initWithRootViewController:music];
//                    UINavigationController *dynamicNavi = [[UINavigationController alloc] initWithRootViewController:dynamic];
//
//                    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//                    tabBarController.viewControllers = @[
//                                                         mainNavi,
//                                                         musicNavi,
//                                                         dynamicNavi,
//                                                         personNavi
//                                                         ];
//                    window.rootViewController = tabBarController;
//
//                    window.backgroundColor = [UIColor whiteColor];
//                    [window makeKeyAndVisible];
//                }
//
//            }else {
//                GODMainViewController *main = [[GODMainViewController alloc] init];
//                GODMusicViewController *music = [[GODMusicViewController alloc] init];
//                GODPersonViewController *person = [[GODPersonViewController alloc] init];
//                GODDynamicController *dynamic = [[GODDynamicController alloc] init];
//                UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:main];
//                UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:person];
//                UINavigationController *musicNavi = [[UINavigationController alloc] initWithRootViewController:music];
//                UINavigationController *dynamicNavi = [[UINavigationController alloc] initWithRootViewController:dynamic];
//
//                UITabBarController *tabBarController = [[UITabBarController alloc] init];
//                tabBarController.viewControllers = @[
//                                                     mainNavi,
//                                                     musicNavi,
//                                                     dynamicNavi,
//                                                     personNavi
//                                                     ];
//                window.rootViewController = tabBarController;
//
//                window.backgroundColor = [UIColor whiteColor];
//                [window makeKeyAndVisible];
//            }
//        });
//    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            GODMainViewController *main = [[GODMainViewController alloc] init];
//            GODMusicViewController *music = [[GODMusicViewController alloc] init];
//            GODPersonViewController *person = [[GODPersonViewController alloc] init];
//            GODDynamicController *dynamic = [[GODDynamicController alloc] init];
//            UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:main];
//            UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:person];
//            UINavigationController *musicNavi = [[UINavigationController alloc] initWithRootViewController:music];
//            UINavigationController *dynamicNavi = [[UINavigationController alloc] initWithRootViewController:dynamic];
//
//            UITabBarController *tabBarController = [[UITabBarController alloc] init];
//            tabBarController.viewControllers = @[
//                                                 mainNavi,
//                                                 musicNavi,
//                                                 dynamicNavi,
//                                                 personNavi
//                                                 ];
//            window.rootViewController = tabBarController;
//
//            window.backgroundColor = [UIColor whiteColor];
//            [window makeKeyAndVisible];
//        });
//    }];
}
@end
