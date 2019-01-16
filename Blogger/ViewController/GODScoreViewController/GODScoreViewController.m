//
//  GODScoreViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODScoreViewController.h"
#import "GODDefine.h"
#import "UIColor+CustomColors.h"

@interface GODScoreViewController ()
<
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *scrollView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *prompLabel;
@end

@implementation GODScoreViewController

- (UITableView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.tableFooterView = [UIView new];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    CGFloat height = 30;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Height - Width - height, Width, Width)];
    NSInteger count = arc4random()%3 + 1;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pro-ad-cat0%ld_500x500_",(long)count]];
    [self.scrollView addSubview:self.imageView];
    
    self.prompLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, Width, 50)];
    self.prompLabel.textAlignment  = NSTextAlignmentCenter;
    self.prompLabel.text = @"继续下拉关闭";
    self.prompLabel.textColor = [UIColor customGrayColor];
    self.prompLabel.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:self.prompLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, Width, (Height - Width - height)/3 - 50)];
    nameLabel.text = @"GodzzZZZ";
    nameLabel.textColor = [UIColor customGrayColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:25];
    [self.scrollView addSubview:nameLabel];
    
    UILabel *slognLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (Height - Width - height)/3, Width, (Height - Width - height)/3)];
    slognLabel.text = @"無限大な夢のあとの 何もない世の中じゃ";
    slognLabel.textColor = color(200, 200, 200, 1);
    slognLabel.textAlignment = NSTextAlignmentCenter;
    slognLabel.font = [UIFont systemFontOfSize:18];
    [self.scrollView addSubview:slognLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"去 App Store 评价" forState:UIControlStateNormal];
    NSString *content = button.titleLabel.text;
    UIFont *font = button.titleLabel.font;
    CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
    CGSize buttonSize = [content boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font} context:nil].size;
    button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.center = CGPointMake(Width/2, (Height - Width - height)*5/6);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    [self.scrollView addSubview:button];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"pro-ad-close_26x26_"] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(20, 30, 17, 17);
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:cancel];
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", @(1195737826)]] options:@{} completionHandler:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offset = self.scrollView.contentOffset.y;
    if (offset < -100) {
        self.prompLabel.text = @"可以松手了";
    }else {
        self.prompLabel.text = @"继续下拉关闭";
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float offset = self.scrollView.contentOffset.y;
    if (offset <= -100) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
