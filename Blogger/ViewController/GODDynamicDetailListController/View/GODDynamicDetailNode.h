//
//  GODDynamicDetailNode.h
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "NetworkImageNode.h"
#import "GODDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GODDynamicDetailNode : ASCellNode
@property(nonatomic, strong) NetworkImageNode *profilePhotoNode;
@property(nonatomic, strong) ASTextNode2 *summaryNode;

@property(nonatomic, strong) ASTextNode2 *dateNode;
@property(nonatomic, strong) ASImageNode *likeNode;
@property(nonatomic, strong) ASTextNode2 *countNode;
@property(nonatomic, strong) ASImageNode *commentNode;

//- (instancetype)initWithModel:(GODDynamicModel *)model;
@end

NS_ASSUME_NONNULL_END
