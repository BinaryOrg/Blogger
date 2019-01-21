
//
//  GODUserHeaderView.m
//  Blogger
//
//  Created by Maker on 2019/1/21.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODUserHeaderView.h"
#import <UIImageView+YYWebImage.h>
@interface GODUserHeaderView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;


@end

@implementation GODUserHeaderView

-(instancetype)init {
    if (self = [super init]) {
        [self setupUI];
        GODUserModel *user = [GODUserTool shared].user;
        if (user) {
            [self.imgView setYy_imageURL:[NSURL URLWithString:user.avatar]];
            [self.btn setTitle:user.username forState:UIControlStateNormal];
        }else {
            [self.btn setTitle:@"登录" forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgView];
    [self addSubview:self.btn];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.imgView.mas_right).mas_equalTo(12);
    }];
    
}

- (void)clickLoginBtn {
    GODUserModel *user = [GODUserTool shared].user;
    if (!user) {
        if (self.clickLogBtn) {
            self.clickLogBtn();
        }
    }
}

- (void)clickAvatar {
    GODUserModel *user = [GODUserTool shared].user;
    if (user) {
        if (self.clickUserIcon) {
            self.clickUserIcon();
        }
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 30;
        _imgView.image = [UIImage imageNamed:@"iosUser_24x24_"];
        _imgView.userInteractionEnabled = YES;
        [_imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)]];
    }
    return _imgView;
}

-(UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_btn setTitleColor:GODColor(215, 171, 112) forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn setShowsTouchWhenHighlighted:NO];
        [_btn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btn;
}


@end
