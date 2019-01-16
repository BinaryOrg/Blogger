//
//  GODTableCard.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODTableCard.h"
#import "GODDefine.h"
@implementation GODTableCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = color(200, 200, 200, 1).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4].CGPath;
    }
    return self;
}

@end
