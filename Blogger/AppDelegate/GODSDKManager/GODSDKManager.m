//
//  GODSDKManager.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODSDKManager.h"
#import <MFNetworkManager/MFNetworkManager.h>
#import <MFHUDManager/MFHUDManager.h>
#import "GODSDKConfigKey.h"
@interface GODSDKManager()
<
MFNetworkManagerDelegate
>
@end
@implementation GODSDKManager
+ (instancetype)sharedInstance {
    static GODSDKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/**
 *  启动，初始化
 */
- (void)launchInWindow:(UIWindow *)window {
    
    [MFHUDManager setHUDType:MFHUDTypeNormal];
    [MFNETWROK startMonitorNetworkType];
    MFNETWROK.baseURL = BASE_URL;
    MFNETWROK.delegate = self;
}

- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt {
    if (![MFHUDManager isShowing]) {
        [MFHUDManager showWarning:prompt];
    }
}
- (void)networkManager:(MFNetworkManager *)manager disDisConnectedWithPrompt:(NSString *)prompt {
    if (![MFHUDManager isShowing]) {
        [MFHUDManager showError:prompt];
    }
}
@end
