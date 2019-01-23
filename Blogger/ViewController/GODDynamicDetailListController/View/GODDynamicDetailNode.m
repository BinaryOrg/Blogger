//
//  GODDynamicDetailNode.m
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicDetailNode.h"
#import "GODSDKConfigKey.h"
#import <DateTools/DateTools.h>

@interface GODDynamicDetailNode ()
@property (nonatomic, strong) ASDisplayNode *lineNode;
@end

@implementation GODDynamicDetailNode
- (instancetype)initWithModel:(GODDetailModel *)model {
    self  = [super init];
    if (self) {
        self.model = model;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.dateNode = [[ASTextNode2 alloc] init];
        self.dateNode.attributedText = [self dateAttributedStringWithFontSize:14];
        [self addSubnode:self.dateNode];
        
        self.profilePhotoNode = [[NetworkImageNode alloc] init];
        self.profilePhotoNode.URL = [NSURL URLWithString:model.user.avatar.length ? [NSString stringWithFormat:@"%@%@", BASE_AVATAR_URL, model.user.avatar] : @"http://a3.att.hudong.com/58/63/01300542846491148697637760361.jpg"];
        [self addSubnode:self.profilePhotoNode];
        self.profilePhotoNode.style.preferredSize = CGSizeMake(22, 22);
        self.profilePhotoNode.cornerRadius = 11;
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
    ASStackLayoutSpec *stack1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:15 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.profilePhotoNode, self.dateNode]];
    
    ASStackLayoutSpec *stack5 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:15 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[stack1, self.summaryNode]];
    
    ASStackLayoutSpec *stack6 = [ASStackLayoutSpec verticalStackLayoutSpec];
    stack6.spacing = 15;
    stack6.children = @[stack5, self.lineNode];
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:stack6];
    return insetSpec;
}


- (NSAttributedString *)summaryAttributedStringWithFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:self.model.append attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size],
                                                                                      NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (NSAttributedString *)dateAttributedStringWithFontSize:(CGFloat)size {
    NSString *date = [[self worldDateToLocalDate:self.model.date] timeAgoSinceNow] ?:@"刚刚";
    return [[NSAttributedString alloc] initWithString:date attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size], NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (NSDate *)worldDateToLocalDate:(NSDate *)date {
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:-offset];
    return localDate;
}

@end
