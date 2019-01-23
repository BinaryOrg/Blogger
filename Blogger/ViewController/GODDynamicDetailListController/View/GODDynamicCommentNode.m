//
//  GODDynamicCommentNode.m
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicCommentNode.h"
#import "GODSDKConfigKey.h"
#import <DateTools/DateTools.h>

@interface GODDynamicCommentNode ()
@property (nonatomic, strong) ASDisplayNode *lineNode;
@end

@implementation GODDynamicCommentNode

- (instancetype)initWithModel:(GODDynamicModel *)model {
    self  = [super init];
    if (self) {
        self.model = model;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentNode = [[ASImageNode alloc] init];
        self.commentNode.style.preferredSize = CGSizeMake(18, 18);
        self.commentNode.image = [UIImage imageNamed:@"ic_messages_repost_20x20_"];
        [self addSubnode:self.commentNode];
        [self.commentNode addTarget:self action:@selector(comment) forControlEvents:ASControlNodeEventTouchUpInside];
        
        self.likeNode = [[ASImageNode alloc] init];
        self.likeNode.style.preferredSize = CGSizeMake(18, 18);
        self.likeNode.image = model.is_like ? [UIImage imageNamed:@"ic_messages_like_selected_20x20_"] : [UIImage imageNamed:@"ic_messages_like_20x20_"];
        [self addSubnode:self.likeNode];
        [self.likeNode addTarget:self action:@selector(like) forControlEvents:ASControlNodeEventTouchUpInside];
        
        self.countNode = [[ASTextNode2 alloc] init];
        self.countNode.attributedText = [self countAttributedStringWithFontSize:14];
        [self addSubnode:self.countNode];
        
        self.dateNode = [[ASTextNode2 alloc] init];
        self.dateNode.attributedText = [self dateAttributedStringWithFontSize:14];
        [self addSubnode:self.dateNode];
        
        self.profilePhotoNode = [[NetworkImageNode alloc] init];
        self.profilePhotoNode.URL = [NSURL URLWithString:model.user.avatar.length ? [NSString stringWithFormat:@"%@%@", BASE_AVATAR_URL, model.user.avatar] : @"http://a3.att.hudong.com/58/63/01300542846491148697637760361.jpg"];
        [self addSubnode:self.profilePhotoNode];
        self.profilePhotoNode.style.preferredSize = CGSizeMake(22, 22);
        self.profilePhotoNode.cornerRadius = 11;
        
        self.nickNode = [[ASTextNode2 alloc] init];
        self.nickNode.attributedText = [self nickAttributedStringWithFontSize:15];
        [self addSubnode:self.nickNode];
        
        self.summaryNode = [[ASTextNode2 alloc] init];
        self.summaryNode.attributedText = [self summaryAttributedStringWithFontSize:16];
        [self addSubnode:self.summaryNode];
        
        _lineNode = [ASDisplayNode new];
        _lineNode.backgroundColor = GODColor(238, 238, 238);
        [_lineNode setLayerBacked:YES];
        _lineNode.style.preferredSize = CGSizeMake(Width - 40, 1.0f);
        [self addSubnode:_lineNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *stack1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.commentNode]];
    ASStackLayoutSpec *stack2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:6 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.likeNode, self.countNode]];
    ASStackLayoutSpec *stack3 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[stack2, stack1]];
    
    ASStackLayoutSpec *stack4 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsCenter children:@[self.dateNode, stack3]];
   
    ASStackLayoutSpec *stack7 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:15 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.profilePhotoNode, self.nickNode]];
    
    ASStackLayoutSpec *stack5 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:15 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[stack7, self.summaryNode, stack4]];
    
    
    
    ASStackLayoutSpec *stack6 = [ASStackLayoutSpec verticalStackLayoutSpec];
    stack6.spacing = 15;
    stack6.children = @[stack5, self.lineNode];
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:stack6];
    return insetSpec;
}

- (void)like {
    if (self.model.is_like) {
        return;
    }
    !self.delegate ?: [self.delegate clickLikeButton:self];
    self.model.like_count += 1;
    self.model.is_like = YES;
    self.countNode.attributedText = [self countAttributedStringWithFontSize:14];
    self.likeNode.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"like" object:nil];
}

- (void)comment {
    !self.delegate ?: [self.delegate clickCommentButton:self];
}

- (NSAttributedString *)summaryAttributedStringWithFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:self.model.summary attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                                                                                      NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (NSAttributedString *)dateAttributedStringWithFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:[[self worldDateToLocalDate:self.model.date] timeAgoSinceNow] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size], NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (NSDate *)worldDateToLocalDate:(NSDate *)date {
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:-offset];
    return localDate;
}

- (NSAttributedString *)countAttributedStringWithFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(self.model.like_count)] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                                                                                   NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (NSAttributedString *)nickAttributedStringWithFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.model.user.username] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                                                                                                                               NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

@end
