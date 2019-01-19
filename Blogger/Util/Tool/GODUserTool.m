//
//  GODUserTool.m
//  小灯塔
//
//  Created by 李小南 on 2018/4/4.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import "GODUserTool.h"
#import "NSObject+YYModel.h"

#define GODUserPhoneKey @"userPhone"
#define GODUserTokenKey @"userToken"
#define GODUserInfoKey  @"userInfo"

@implementation GODUserTool

static GODUserTool *userTool = nil;

+ (GODUserTool *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userTool = [[self alloc] init];
        
        userTool.token = [[NSUserDefaults standardUserDefaults] objectForKey:GODUserTokenKey];
        userTool.phone = [[NSUserDefaults standardUserDefaults] objectForKey:GODUserPhoneKey];
        
        // 取出字典, 转成模型后赋值
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:GODUserInfoKey];
        if (!dict) {
            return;
        }
        userTool.user = [GODUserModel yy_modelWithDictionary:dict];
        
    });
    return userTool;
}

/// 是否登陆
+ (BOOL)isLogin {
    return [GODUserTool shared].user.userId.length ? YES : NO;
}

/// 清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GODUserTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GODUserInfoKey];
    _user = nil;
    _token = @"";
    
}

#pragma mark - setter
- (void)setToken:(NSString *)token {
    /// 如果token为空, 不覆盖本地token
    if (token.length) {
        _token = token;
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:GODUserTokenKey];
    }
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:GODUserPhoneKey];
}

- (void)setUser:(GODUserModel *)user {
    if (!user) {
        return;
    }
   
    _user = user;
    
    // 将模型转为json字典后, 存在本地
    NSDictionary *dict = [user yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:GODUserInfoKey];
    
}
@end
