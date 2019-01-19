//
//  NSString+Regex.h
//  小灯塔
//
//  Created by 李小南 on 2018/4/13.
//  Copyright © 2018年 TheTiger. All rights reserved.
//  正则专用 NSString 分类

#import <Foundation/Foundation.h>

@interface NSString (Regex)
/**
 *  得到中英文混合字符串长度
 */
- (NSInteger)getToInt;

/**
 *  正则判断是否是 手机号 11位1开头的阿拉伯数字
 */
- (BOOL)isMobileNumber;

/**
 *  正则判断是否是 纯数字
 */
- (BOOL)isNumber;

/**
 *  正则判断是否是 微信格式
 */
- (BOOL)isWeChatNumber;
@end
