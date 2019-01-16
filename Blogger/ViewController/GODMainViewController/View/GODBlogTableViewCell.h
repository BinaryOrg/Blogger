//
//  GODBlogTableViewCell.h
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GODTableCard.h"
@interface GODBlogTableViewCell : UITableViewCell
@property (nonatomic ,strong) GODTableCard *containerView;
@property (nonatomic, strong) UIImageView *blogImageView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *summaryLabel;
@property (nonatomic ,strong) UILabel *yearLabel;

@property (nonatomic ,strong) UIButton *button;
@end
