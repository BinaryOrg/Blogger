//
//  GODToolNode.m
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODToolNode.h"
#import "NSMutableDictionary+Attributes.h"
#import "NSMutableAttributedString+Chain.h"
#import "ASButtonNode+LHExtension.h"
#import "UIView+LH.h"
#import "GODSDKConfigKey.h"
#import "NetworkImageNode.h"
@interface GODToolNode ()

@property (nonatomic, strong) ASButtonNode *thumbNode;
@property (nonatomic, strong) ASButtonNode *commentNode;
@property (nonatomic, strong) NetworkImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) GODDynamicModel *model;
@end

@implementation GODToolNode

- (instancetype)initWithModel:(GODDynamicModel *)model {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.model = model;
    void(^attributes)(NSMutableDictionary *make) = ^(NSMutableDictionary *make) {
        make.lh_font([UIFont systemFontOfSize:12.0f]).lh_color([UIColor colorWithHexString:@"354048"]);
    };
    
    NSString *thubCount = [NSString stringWithFormat:@"%zd", model.like_count];
    if (model.like_count == 0) {
        thubCount = @"";
    }
    _thumbNode = [[ASButtonNode alloc] init];
    [_thumbNode lh_setEnlargeEdgeWithTop:10.0f right:15.0f bottom:10.0f left:15.0f];
    [_thumbNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:thubCount attributes:attributes] forState:UIControlStateNormal];
    [_thumbNode setImage:[UIImage imageNamed:@"ic_messages_like_20x20_"] forState:UIControlStateNormal];
    [_thumbNode setImage:[UIImage imageNamed:@"ic_messages_like_selected_20x20_"] forState:UIControlStateSelected];
    [_thumbNode addTarget:self action:@selector(onTouchThumbNode:) forControlEvents:ASControlNodeEventTouchUpInside];
    _thumbNode.selected = model.is_like;
    
    NSString *commentCount = [NSString stringWithFormat:@"%d", 0];
//    if (model.commentTotal == 0) {
        commentCount = @"";
//    }
    _commentNode = [[ASButtonNode alloc] init];
    [_thumbNode lh_setEnlargeEdgeWithTop:10.0f right:15.0f bottom:10.0f left:15.0f];
    [_commentNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:commentCount attributes:attributes] forState:UIControlStateNormal];
    [_commentNode setImage:[UIImage imageNamed:@"bnt_comment"] forState:UIControlStateNormal];
    [_commentNode addTarget:self action:@selector(onTouchCommentNode:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    _titleNode = [ASTextNode new];
    _titleNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.user.username attributes:^(NSMutableDictionary *make) {
        make.lh_font([UIFont systemFontOfSize:12.0f]).lh_color([UIColor colorWithHexString:@"354048"]);
    }];
    
    
    _titleNode.textContainerInset = UIEdgeInsetsMake((24 - [UIFont systemFontOfSize:12.0f].lineHeight)/2.0f, 21, 0, 12);
    _titleNode.backgroundColor = GODColor(255, 251, 233);
    _titleNode.style.minHeight = ASDimensionMake(24);
    _titleNode.cornerRadius = 12;
    _titleNode.style.maxWidth = ASDimensionMake(Width - 165 - 33);
    [_titleNode addTarget:self action:@selector(onTouchCoterieNode) forControlEvents:ASControlNodeEventTouchUpInside];
    
    _iconNode = [[NetworkImageNode alloc] init];
    _iconNode.cornerRadius = 12;
//    _iconNode.defaultImage = LHPlaceholderCoverImage01;
    _iconNode.URL = [NSURL URLWithString:model.user.avatar.length ? [NSString stringWithFormat:@"%@%@", BASE_AVATAR_URL, model.user.avatar] : @"http://a3.att.hudong.com/58/63/01300542846491148697637760361.jpg"];
    _iconNode.style.preferredSize = CGSizeMake(24, 24);
    [_iconNode addTarget:self action:@selector(onTouchCoterieNode) forControlEvents:ASControlNodeEventTouchUpInside];
    
    
    [self addSubnode:_thumbNode];
    [self addSubnode:_commentNode];
    [self addSubnode:_titleNode];
    [self addSubnode:_iconNode];
    return self;
}

- (void)onTouchThumbNode:(ASButtonNode *)node {
    if (self.model.is_like) {
        return;
    }
    void(^attributes)(NSMutableDictionary *make) = ^(NSMutableDictionary *make) {
        make.lh_font([UIFont systemFontOfSize:12.0f]).lh_color([UIColor colorWithHexString:@"354048"]);
    };
    self.model.is_like = !self.model.is_like;
    self.model.like_count += 1;
    NSString *thubCount = [NSString stringWithFormat:@"%zd", self.model.like_count];
    if (self.model.like_count == 0) {
        thubCount = @"";
    }
    [self.thumbNode setAttributedTitle:[NSMutableAttributedString lh_makeAttributedString:thubCount attributes:attributes] forState:UIControlStateNormal];
    self.thumbNode.selected = self.model.is_like;
    SAFE_BLOCK(self.didClickThumbNodeBlock);
}

- (void)onTouchCommentNode:(ASButtonNode *)node {
    SAFE_BLOCK(self.didClickCommentNodeBlock);
}

- (void)onTouchCoterieNode {
    SAFE_BLOCK(self.didClickCoterieNodeBlock);
}


-(void)didLoad {
    [super didLoad];
    CGFloat w = [self.titleNode.attributedText boundingRectWithSize:CGSizeMake(Width - 165, 24) options:0 context:nil].size.width + 33;
    [self.titleNode.view addRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopRight withRadii:CGSizeMake(24, 24) viewRect:CGRectMake(0, 0, w, 24)];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    ASStackLayoutSpec *commentLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:30.0f justifyContent:ASStackLayoutJustifyContentEnd alignItems:ASStackLayoutAlignItemsCenter children:@[_commentNode, _thumbNode]];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, -12, 0, INFINITY);
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:inset child:_iconNode];
    ASOverlayLayoutSpec *overLay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_titleNode overlay:insetLayout];
    
    ASStackLayoutSpec *verSpec =[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10.0f justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsCenter children:@[overLay, commentLayout]];
    
    ASInsetLayoutSpec *allInserSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 12, 0, 0) child:verSpec];
    return allInserSpec;
}

@end
