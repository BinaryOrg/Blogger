//
//  AppDelegate.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "AppDelegate.h"
#import "GODSDKManager/GODSDKManager.h"
#import "GODLaunchManager/GODLaunchManager.h"
#import <JPush/JPUSHService.h>
#import "GODSDKConfigKey.h"
#import <MFHUDManager/MFHUDManager.h>
#import <UserNotifications/UserNotifications.h>
#import <AVOSCloud/AVOSCloud.h>
@interface AppDelegate ()
<
JPUSHRegisterDelegate
>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [AVOSCloud setApplicationId:@"l1NXJfT2CaNlAWEafzM533Xp-gzGzoHsz" clientKey:@"6DkL9slHraowk55xAVW1AiiL"];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[GODSDKManager sharedInstance] launchInWindow:self.window];
    [[GODLaunchManager sharedInstance] launchInWindow:self.window];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //自定义消息，目前不用
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    
    return YES;
}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
////    [MFHUDManager showSuccess:@"请刷新 Blogger 查看最新内容！"];
//    NSDictionary * userInfo = [notification userInfo];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *subtitle = [extras valueForKey:@"subtitle"];
//    NSString *body = [extras valueForKey:@"body"];
//    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
//    content.title = @"请刷新 Blogger 查看最新内容！";
//    content.subtitle = subtitle;
//    content.body = body;
//    content.badge = @0;
//
//    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
//    trigger.timeInterval = 1;
//    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
//    request.requestIdentifier = @"GodzzZZZ";
//    request.content = content;
//    request.trigger = trigger;
//    request.completionHandler = ^(id result) {
//
//    };
//    [JPUSHService addNotification:request];
//}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
