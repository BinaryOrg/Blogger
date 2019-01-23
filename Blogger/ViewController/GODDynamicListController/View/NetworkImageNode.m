//
//  NetworkImageNode.m
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "NetworkImageNode.h"
#import <YYWebImage/YYWebImage.h>

#define HAVE_CACHE_IMAGE(str)   [[YYImageCache sharedCache] containsImageForKey:str] //判断是否存在缓存键值
#define CACHE_IMAGE(str)   [[YYImageCache sharedCache] getImageForKey:str]//获取缓存图片

@interface NetworkImageNode ()
<ASNetworkImageNodeDelegate>
@property(nonatomic, strong) ASNetworkImageNode *networkImageNode;
@property(nonatomic, strong) ASImageNode *imageNode;
@end

@implementation NetworkImageNode

- (ASNetworkImageNode *)networkImageNode {
    if (!_networkImageNode) {
        _networkImageNode = [[ASNetworkImageNode alloc] init];
        _networkImageNode.delegate = self;
        _networkImageNode.shouldCacheImage = NO;
    }
    return _networkImageNode;
}

- (ASImageNode *)imageNode {
    if (!_imageNode) {
        _imageNode = [[ASImageNode alloc] init];
    }
    return _imageNode;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.networkImageNode.cornerRadius = cornerRadius;
    self.imageNode.cornerRadius = cornerRadius;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.networkImageNode.placeholderColor = placeholderColor;
    _placeholderColor = placeholderColor;
}

- (void)setImage:(UIImage *)image {
    self.networkImageNode.image = image;
    _image = image;
}

- (NSTimeInterval)placeholderFadeDuration {
    return self.networkImageNode.placeholderFadeDuration;
}

- (void)setURL:(NSURL *)url {
    _URL = url;
    if (HAVE_CACHE_IMAGE(url.absoluteString)) {
        self.imageNode.image = CACHE_IMAGE(url.absoluteString);
    }else {
        self.networkImageNode.URL = url;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubnode:self.networkImageNode];
        [self addSubnode:self.imageNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:!HAVE_CACHE_IMAGE(self.URL.absoluteString) ? self.networkImageNode : self.imageNode];
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    [[YYImageCache sharedCache] setImage:image forKey:imageNode.URL.absoluteString];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEventMask {
    [self.networkImageNode addTarget:target action:action forControlEvents:controlEventMask];
    [self.imageNode addTarget:target action:action forControlEvents:controlEventMask];
}

@end
