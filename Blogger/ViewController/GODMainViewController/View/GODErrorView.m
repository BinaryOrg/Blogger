//
//  GODErrorView.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODErrorView.h"
#import "GODDefine.h"
#import "UIColor+CustomColors.h"
@implementation GODErrorView

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-failure-placeholder"]];
        imageView.center = self.center;
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, Width, 40)];
        self.errorLabel.font = [UIFont systemFontOfSize:16];
        self.errorLabel.textColor = [UIColor customGrayColor];
        self.errorLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.errorLabel];
        
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadButton.frame = self.errorLabel.bounds;
        [self.errorLabel addSubview:self.reloadButton];
    }
    return self;
}

@end
