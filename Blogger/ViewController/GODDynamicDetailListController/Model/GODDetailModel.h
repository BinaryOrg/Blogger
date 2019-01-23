//
//  GODDetailModel.h
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GODDetailModel : NSObject
@property (nonatomic, strong) GODUserModel *user;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *append;
@end

NS_ASSUME_NONNULL_END
