//
//  GODPersonViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODPersonViewController.h"
#import <YYCache.h>
#import <MFHUDManager.h>
#import <StoreKit/StoreKit.h>
#import <YYWebImage/YYWebImage.h>
#import "UIColor+CustomColors.h"
#import "GODAvatarTableViewCell.h"
#import "GODConfigurationTableViewCell.h"
#import "GODScoreViewController.h"
#import "GODPostController.h"
#import "GODLoginTelephoneViewController.h"
#import "GODUserHeaderView.h"

@interface GODPersonViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SKStoreProductViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) GODAvatarTableViewCell *avatarCell;
@property (nonatomic ,strong) NSArray *textList;
@end

@implementation GODPersonViewController

- (NSArray *)textList {
    if (!_textList) {
        _textList = @[
                      @"清除缓存",
                      @"用户评价",
                      @"联系作者",
                      @"发布内容",
                      ];
    }
    return _textList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"iosUser_24x24_"];
        UIImage *selectedImage = [[UIImage imageNamed:@"iosUserS_24x24_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"账户" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"account";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self addHeaderView];
}

- (void)addHeaderView {
    GODUserHeaderView *header = [[GODUserHeaderView alloc] init];
    header.frame = CGRectMake(0, 0, Width, 120);
    __weak typeof(self)weakSelf = self;
    //点击登录
    header.clickLogBtn = ^{
        GODLoginTelephoneViewController *vc = [[GODLoginTelephoneViewController alloc] init];
        [weakSelf presentViewController:vc animated:YES completion:nil];
        vc.didLoginSuccessBlock = ^{
            [weakSelf addHeaderView];
        };
    };
    //点击用户头像
    header.clickUserIcon = ^{
        
    };
    self.tableView.tableHeaderView = header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    GODConfigurationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GODConfigurationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",@(indexPath.row+1)]];
    cell.label.text = self.textList[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self presentViewController:[[GODScoreViewController alloc] init] animated:YES completion:nil];
    }
    else if (indexPath.row == 2) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"Shmily_liuyy";
        [MFHUDManager showSuccess:@"作者微信号已成功复制到剪切板！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:@"weixin://"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        });
    }
    if (indexPath.row == 3) {
        if ([GODUserTool shared].user.id.length == 0) {//没有登录
            [self presentViewController:[[GODLoginTelephoneViewController alloc] init] animated:YES completion:nil];
        }else {
            [self presentViewController:[[GODPostController alloc] init] animated:YES completion:nil];
        }
    }
    else {
        [[GODUserTool shared] clearUserInfo];
        [self addHeaderView];
        if ([MFHUDManager isShowing]) {
            return;
        }else {
            [[YYImageCache sharedCache].diskCache removeAllObjects];
            [[YYImageCache sharedCache].memoryCache removeAllObjects];
            
            [MFHUDManager showLoading:@"正在清除..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MFHUDManager showSuccess:@"清除成功!"];
            });
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
