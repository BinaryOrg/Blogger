//
//  GODCard.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODCard.h"
#import "GODDefine.h"
@implementation GODCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCorner:5 bgColor:[UIColor whiteColor] borderWidth:0.1 borderColor:[UIColor whiteColor]];
    }
    return self;
}

- (UIImage *)drawRectWithCorner:(float)radius
                        bgColor:(UIColor *)bgColor
                    borderWidth:(float)borderWidth
                    borderColor:(UIColor *)borderColor {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    
    CGRect bounds = CGRectMake(borderWidth / 2.f, borderWidth / 2.f, self.bounds.size.width - borderWidth, self.bounds.size.height - borderWidth);
    
    CGContextMoveToPoint(context, CGRectGetMinX(bounds), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds), radius, CGRectGetMinY(bounds), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds) + radius, radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds) - radius, CGRectGetMaxY(bounds), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - radius, radius);
    
    CGContextClosePath(context);
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


- (void)addCorner:(float)radius
          bgColor:(UIColor *)bgColor
      borderWidth:(float)borderWidth
      borderColor:(UIColor *)borderColor {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [self drawRectWithCorner:radius bgColor:bgColor borderWidth:borderWidth / 2.f borderColor:borderColor];
    [self insertSubview:imageView atIndex:0];
}

@end
