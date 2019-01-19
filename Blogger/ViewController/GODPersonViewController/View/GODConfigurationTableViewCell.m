//
//  GODConfigurationTableViewCell.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODConfigurationTableViewCell.h"
@implementation GODConfigurationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 25, 22)];
        [self.contentView addSubview:self.leftImageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, Width - 65 - 50, 50)];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.center = CGPointMake(self.indicatorView.bounds.size.width/2, self.label.bounds.size.height/2);
        [self.label addSubview:self.indicatorView];
    }
    return self;
}

@end
