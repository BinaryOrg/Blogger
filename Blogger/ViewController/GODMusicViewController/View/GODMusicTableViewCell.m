//
//  GODMusicTableViewCell.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODMusicTableViewCell.h"
#import "GODDefine.h"
#import "UIColor+CustomColors.h"
@implementation GODMusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[GODTableCard alloc] initWithFrame:CGRectMake(10, 5, Width-20, 270)];
        [self.contentView addSubview:self.containerView];
        
        self.musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width - 20, 160)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.musicImageView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.musicImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.musicImageView.layer.mask = maskLayer;
        self.musicImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.containerView addSubview:self.musicImageView];
        self.musicImageView.userInteractionEnabled = YES;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, Width - 20, 40)];
        bgView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self.musicImageView addSubview:bgView];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(10, 5, 30, 30);
        
        [bgView addSubview:self.playButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame) + 5, 0, Width - 20 - 20 - 60 - 20 - 5 - 45, 40)];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [bgView addSubview:self.titleLabel];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, 0, 60, 40)];
        self.durationLabel.textColor = [UIColor whiteColor];
        self.durationLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:self.durationLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.durationLabel.frame), 12.5, 15, 15)];
        imageView.image = [UIImage imageNamed:@"btn-random-music-active"];
        [bgView addSubview:imageView];
        
        self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.musicImageView.frame), Width - 20 - 20, 30)];
        self.artistLabel.textColor = [UIColor customGrayColor];
        self.artistLabel.font = [UIFont systemFontOfSize:16];
        [self.containerView addSubview:self.artistLabel];
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.artistLabel.frame), Width - 20 - 20, 80)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.summaryLabel.font = [UIFont systemFontOfSize:12];
        
        [self.containerView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
