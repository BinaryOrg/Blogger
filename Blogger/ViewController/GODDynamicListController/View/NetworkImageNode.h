//
//  NetworkImageNode.h
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface NetworkImageNode : ASDisplayNode
@property(nonatomic, strong) UIColor *placeholderColor;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, assign) CGFloat cornerRadius;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask;
@end

