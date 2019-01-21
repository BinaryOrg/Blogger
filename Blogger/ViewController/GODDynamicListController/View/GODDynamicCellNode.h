//
//  GODDynamicCellNode.h
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//
#import "GODToolNode.h"
@class GODDynamicCellNode;
@protocol GODDynamicCellNodeDelegate<NSObject>

- (void)clickEnjoyWithNode:(GODDynamicCellNode *)cellNode;

@end
NS_ASSUME_NONNULL_BEGIN

@interface GODDynamicCellNode : ASCellNode


@property (nonatomic, weak) id <GODDynamicCellNodeDelegate> delegate;

- (instancetype)initWithModel:(GODDynamicModel *)model;

@end

NS_ASSUME_NONNULL_END
