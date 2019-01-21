//
//  ASButtonNode+LHExtension.m
//  小灯塔
//
//  Created by liuhao on 2018/11/26.
//  Copyright © 2018 TheTiger. All rights reserved.
//

#import "ASButtonNode+LHExtension.h"
#import <objc/runtime.h>

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation ASButtonNode (LHExtension)



- (void)lh_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber *topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge ||
        rightEdge ||
        bottomEdge ||
        leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    return self.bounds;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point);
}

@end
