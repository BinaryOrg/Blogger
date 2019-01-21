//
//  GODToolNode.h
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GODToolNode : ASDisplayNode

@property (nonatomic, copy) void(^didClickThumbNodeBlock)(void);
@property (nonatomic, copy) void(^didClickCommentNodeBlock)(void);
@property (nonatomic, copy) void(^didClickCoterieNodeBlock)(void);

- (instancetype)initWithModel:(GODDynamicModel *)model;
@end

NS_ASSUME_NONNULL_END
