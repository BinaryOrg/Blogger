//
//  AvatarTableViewCell.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODAvatarTableViewCell.h"
#import "UIColor+CustomColors.h"
@implementation GODAvatarTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
        CGPoint center = self.avatarImageView.center;
        center.x = Width/2;
        self.avatarImageView.center = center;
        [self.contentView addSubview:self.avatarImageView];
        self.avatarImageView.userInteractionEnabled = YES;
        self.avatarImageView.layer.cornerRadius = 5;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarButton.frame = self.avatarImageView.bounds;
        [self.avatarImageView addSubview:self.avatarButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, Width, 40)];
        self.nameLabel.text = @"";
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = color(140, 140, 140, 1);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

@end
