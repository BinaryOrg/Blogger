//
//  GODDynamicCommentNode.h
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicModel.h"
#import "NetworkImageNode.h"
NS_ASSUME_NONNULL_BEGIN
@class GODDynamicCommentNode;
@protocol GODDynamicCommentNodeDelegate <NSObject>

- (void)clickLikeButton:(GODDynamicCommentNode *)node;
- (void)clickCommentButton:(GODDynamicCommentNode *)node;

@end

@interface GODDynamicCommentNode : ASCellNode

@property(nonatomic, weak) id<GODDynamicCommentNodeDelegate> delegate;

@property(nonatomic, strong) NetworkImageNode *profilePhotoNode;
@property(nonatomic, strong) ASTextNode2 *nickNode;
@property(nonatomic, strong) ASTextNode2 *summaryNode;

@property(nonatomic, strong) ASTextNode2 *dateNode;
@property(nonatomic, strong) ASImageNode *likeNode;
@property(nonatomic, strong) ASTextNode2 *countNode;
@property(nonatomic, strong) ASImageNode *commentNode;

@property(nonatomic, strong) GODDynamicModel *model;

- (instancetype)initWithModel:(GODDynamicModel *)model;

@end

NS_ASSUME_NONNULL_END
