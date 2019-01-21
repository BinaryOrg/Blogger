//
//  GODDynamicModel.h
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GODUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GODDynamicModel : NSObject
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) GODUserModel *user;
@property (nonatomic, assign) NSInteger id;
@end

NS_ASSUME_NONNULL_END
