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

@property (nonatomic, assign) BOOL isFavor;
@property (nonatomic, assign) NSInteger favorTotal;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) GODUserModel *releaseuser;
@end

NS_ASSUME_NONNULL_END
