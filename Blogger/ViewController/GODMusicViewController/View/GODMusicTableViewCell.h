//
//  GODMusicTableViewCell.h
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GODMusicTableViewCell : UITableViewCell
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIImageView *musicImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *summaryLabel;
@property(nonatomic, strong) UILabel *songNameLabel;
@property(nonatomic, strong) UILabel *artistLabel;
@end
