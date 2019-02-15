//
//  ABCNotificationName.h
//
//  Created by 张冬冬 on 2019/1/24.
//  Copyright © 2019 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCMacro.h"

NS_ASSUME_NONNULL_BEGIN
ZTW_EXTERN NSNotificationName const WXAuthSucceed;
ZTW_EXTERN NSNotificationName const WXAuthDenied;
ZTW_EXTERN NSNotificationName const WXAuthCancel;

@interface ABCNotificationName : NSObject

@end

NS_ASSUME_NONNULL_END
