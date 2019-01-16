//
//  GODBlogTableViewCell.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODBlogTableViewCell.h"
#import "GODDefine.h"
#import "UIColor+CustomColors.h"
@implementation GODBlogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[GODTableCard alloc] initWithFrame:CGRectMake(10, 5, Width-20, 120)];
        [self.contentView addSubview:self.containerView];
        
        self.blogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 110, 110)];
        self.blogImageView.layer.cornerRadius = 3;
        self.blogImageView.layer.masksToBounds = YES;
        self.blogImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.containerView addSubview:self.blogImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogImageView.frame) + 5, 5, Width - 20 - 110 - 10 - 5, 20)];
        [self.containerView addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogImageView.frame) + 5, CGRectGetMaxY(self.titleLabel.frame), Width - 20 - 110 - 10 - 5, 20)];
        [self.containerView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel.textColor = [UIColor customGrayColor];
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogImageView.frame) + 5, CGRectGetMaxY(self.dateLabel.frame), Width - 20 - 110 - 10 - 5, 70)];
        [self.containerView addSubview:self.summaryLabel];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.summaryLabel.font = [UIFont systemFontOfSize:13];
        
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = self.containerView.bounds;
        [self.containerView addSubview:self.button];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
