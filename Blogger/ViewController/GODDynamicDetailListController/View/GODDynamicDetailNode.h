//
//  GODDynamicDetailNode.h
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "NetworkImageNode.h"
#import "GODDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GODDynamicDetailNode : ASCellNode
@property(nonatomic, strong) NetworkImageNode *profilePhotoNode;
@property(nonatomic, strong) ASTextNode2 *summaryNode;
@property(nonatomic, strong) ASTextNode2 *dateNode;
@property(nonatomic, strong) GODDetailModel *model;
- (instancetype)initWithModel:(GODDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
