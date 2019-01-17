//
//  GODMainViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODMainViewController.h"
#import <MFNetworkManager/MFNetworkManager.h>
#import <MJRefresh.h>
#import <YYWebImage.h>
#import <SafariServices/SafariServices.h>
#import <MFHUDManager/MFHUDManager.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "GODDefine.h"
#import "GODBlogTableViewCell.h"
#import "UIColor+CustomColors.h"
#import "GODBlogModel.h"
#import "GODSDKConfigKey.h"

@interface GODMainViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MFNetworkManagerDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *blogList;
@property (nonatomic, assign) BOOL listEmpty;
@property (nonatomic, assign) BOOL shouldDisplay;
@end

@implementation GODMainViewController

- (NSMutableArray *)blogList {
    if (!_blogList) {
        _blogList = @[].mutableCopy;
    }
    return _blogList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, Width, Height - StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) weakSelf = self;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf mf_refreshData];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.textColor = [UIColor customGrayColor];
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        _tableView.mj_header = header;
        
        [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新数据" forState:MJRefreshStateRefreshing];
        _tableView.tag = 10000;
    }
    return _tableView;
}

- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt {
    if (![MFHUDManager isShowing]) {
        [MFHUDManager showWarning:prompt];
    }
    if (!self.blogList.count) {
        self.shouldDisplay = YES;
        [self.tableView reloadData];
        [self sendFirstRequest];
    }
}

- (void)mf_refreshData {
    [MFNETWROK get:@"blogs/year/all" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"success");
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            GODBlogModel *model = [GODBlogModel yy_modelWithJSON:dic];
            [list addObject:model];
        }
        if (list.count) {
            [list sortUsingComparator:^NSComparisonResult(GODBlogModel *obj1, GODBlogModel *obj2) {
                return obj1.tag < obj2.tag;
            }];
            if (self.blogList.count) {
                [self.blogList removeAllObjects];
            }
            [self.blogList addObjectsFromArray:list];
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
            self.listEmpty = NO;
            
        }else {
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
            self.listEmpty = YES;
        }
        self.shouldDisplay = NO;
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.blogList.count) {
            [self.blogList removeAllObjects];
        }
        self.listEmpty = NO;
        self.shouldDisplay = NO;
        [self.tableView reloadData];
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"iosAllNotes_24x24_"];
        UIImage *selectedImage = [[UIImage imageNamed:@"iosAllNotesS_24x24_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Blogger" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MFNETWROK.delegate = self;
    self.title = @"Blogger";
    self.view.backgroundColor = [UIColor whiteColor];
    self.shouldDisplay = YES;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self sendFirstRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [[YYImageCache sharedCache].diskCache removeAllObjects];
//    [[YYImageCache sharedCache].memoryCache removeAllObjects];
}

- (void)sendFirstRequest {
    [MFNETWROK get:@"blogs/year/all" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"success");
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            GODBlogModel *model = [GODBlogModel yy_modelWithJSON:dic];
            [list addObject:model];
        }
        if (list.count) {
            [list sortUsingComparator:^NSComparisonResult(GODBlogModel *obj1, GODBlogModel *obj2) {
                return obj1.tag < obj2.tag;
            }];
            if (self.blogList.count) {
                [self.blogList removeAllObjects];
            }
            [self.blogList addObjectsFromArray:list];
            self.listEmpty = NO;
        }else {
            self.listEmpty = YES;
        }
        self.shouldDisplay = NO;
        [self.tableView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        self.listEmpty = NO;
        self.shouldDisplay = NO;
        [self.tableView reloadData];
        NSLog(@"%@", error.userInfo);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GODBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blog"];
    if (!cell) {
        cell = [[GODBlogTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blog"];
    }
    GODBlogModel *model = self.blogList[indexPath.row];
    [self configCell:cell withModel:model];
    return cell;
    
}

- (void)configCell:(GODBlogTableViewCell *)cell withModel:(GODBlogModel *)model {
    [cell.button addTarget:self action:@selector(cellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button addTarget:self action:@selector(cellButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [cell.button addTarget:self action:@selector(cellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellButtonLongPress:)];
    longPress.minimumPressDuration = 0.8;
    [cell.button addGestureRecognizer:longPress];

    [cell.blogImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", BASE_IMAGE_URL, @(model.tag)]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    cell.titleLabel.text = model.title;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@", model.date, model.year];
    cell.summaryLabel.text = model.summary;
}

- (void)cellButtonLongPress:(UILongPressGestureRecognizer *)gesture {
    GODBlogTableViewCell *cell = (GODBlogTableViewCell *)gesture.view.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.15 animations:^{
            cell.containerView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            GODBlogModel *model = self.blogList[indexPath.row];
            if (self.navigationController.viewControllers.count == 1) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_DETAIL_URL, @(model.tag)]];
                NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", BASE_IMAGE_URL, @(model.tag)]];
                NSString *key = [[YYWebImageManager sharedManager] cacheKeyForURL:imageUrl];
                UIImage *image = [[YYImageCache sharedCache] getImageForKey:key];
                
                NSData *compressData = UIImageJPEGRepresentation(image, 0.1);
                UIImage *compressImage = [UIImage imageWithData:compressData];
                NSString *title = model.title;
                [self shareWithTitle:title image:compressImage link:url];
            }else {
                return;
            }
        }];
    }
}

- (void)shareWithTitle:(NSString *)title image:(UIImage *)image link:(NSURL *)link {
    NSArray *activityItems = @[title, image, link];
    UIActivityViewController * activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    if (@available(iOS 11, *)) {
        activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    }else {
        activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks];
    }
    
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            
           
        }else {
            
        }
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)cellButtonTouchDown:(UIButton *)sender {
    GODBlogTableViewCell *cell = (GODBlogTableViewCell *)sender.superview.superview.superview;
    [UIView animateWithDuration:0.15 animations:^{
        cell.containerView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    }];
}

- (void)cellButtonTouchUpInside:(UIButton *)sender {
    GODBlogTableViewCell *cell = (GODBlogTableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [UIView animateWithDuration:0.15 animations:^{
        cell.containerView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
        GODBlogModel *model = self.blogList[indexPath.row];
        if (self.navigationController.viewControllers.count == 1) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_DETAIL_URL, @(model.tag)]];
            SFSafariViewController *safariVC = nil;
            if (@available(iOS 11.0, *)) {
                SFSafariViewControllerConfiguration *configuration = [[SFSafariViewControllerConfiguration alloc] init];
                configuration.entersReaderIfAvailable = NO;
                safariVC = [[SFSafariViewController alloc] initWithURL:url configuration:configuration];
            } else {
                safariVC = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
            }
            safariVC.preferredBarTintColor = [UIColor themeColor];
            safariVC.preferredControlTintColor = [UIColor whiteColor];
            [self presentViewController:safariVC animated:YES completion:nil];
        }else {
            return;
        }
    }];
}

- (void)cellButtonTouchDragExit:(UIButton *)sender {
    GODBlogTableViewCell *cell = (GODBlogTableViewCell *)sender.superview.superview.superview;
    [UIView animateWithDuration:0.15 animations:^{
        cell.containerView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

#pragma mark - DZN
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"network-failure-placeholder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Oops! Something has gone wrong!";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.shouldDisplay) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        return activityView;
    }
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.listEmpty) {
        return nil;
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName: [UIColor customBlueColor]};
    return [[NSAttributedString alloc] initWithString:@"Retry" attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 20.0f;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    self.shouldDisplay = YES;
    [self.tableView reloadData];
    [self sendFirstRequest];
}

@end
