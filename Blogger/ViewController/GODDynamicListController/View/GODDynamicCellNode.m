//
//  GODDynamicCellNode.m
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicCellNode.h"
#import "GODToolNode.h"
#import "NSMutableAttributedString+Chain.h"

@interface GODDynamicCellNode ()
/** <#class#> */
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) GODToolNode *coterieToolNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;

@end

@implementation GODDynamicCellNode

- (instancetype)initWithModel:(GODDynamicModel *)model {
    self = [super init];
    if (self) {
        __weak typeof(self)weakSelf = self;
        
        
        self.coterieToolNode = [[GODToolNode alloc] initWithModel:model];
        self.coterieToolNode.didClickThumbNodeBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(clickEnjoyWithNode:)]) {
                [weakSelf.delegate clickEnjoyWithNode:weakSelf];
            }
        };
        self.coterieToolNode.didClickCommentNodeBlock = ^{
            
        };
        self.coterieToolNode.didClickCoterieNodeBlock = ^{
            
        };
        [self addSubnode:self.coterieToolNode];
        
        
        NSMutableAttributedString *text = [NSMutableAttributedString lh_makeAttributedString:model.content attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:15.0]).lh_color([UIColor colorWithHexString:@"354048"]);
        }];
        _contentNode = [ASTextNode new];
        _contentNode.linkAttributeNames = @[@"kLinkAttributeName"];
        _contentNode.style.flexShrink = YES;
        _contentNode.style.flexGrow = YES;
        _contentNode.maximumNumberOfLines = 0;
        _contentNode.userInteractionEnabled = YES;
        _contentNode.attributedText = text;
        _contentNode.style.maxWidth = ASDimensionMakeWithPoints(Width - 40);
        [self addSubnode:_contentNode];
        
        _lineNode = [ASDisplayNode new];
        _lineNode.backgroundColor = GODColor(238, 238, 238);
        [_lineNode setLayerBacked:YES];
        _lineNode.style.preferredSize = CGSizeMake(Width - 40, 1.0f);
        [self addSubnode:_lineNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
   
    
    ASStackLayoutSpec *verticalSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    verticalSpec.spacing = 13;
    verticalSpec.children = @[self.contentNode , self.coterieToolNode];
    
    
    ASStackLayoutSpec *lineSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    lineSpec.spacing = 15;
    lineSpec.children = @[verticalSpec, self.lineNode];
    
    ASInsetLayoutSpec *insetLayout = [self insetLayoutWithChild:lineSpec];
    
    return insetLayout;
}

- (ASInsetLayoutSpec *)insetLayoutWithChild:(id<ASLayoutElement>)child {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15.0f, 20.0f, 15.0f, 20.0f) child:child];
}

@end
