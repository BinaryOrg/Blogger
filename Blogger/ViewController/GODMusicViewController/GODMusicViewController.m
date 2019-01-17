//
//  GODMusicViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODMusicViewController.h"
#import "GODDefine.h"
#import "UIColor+CustomColors.h"
#import <MFHUDManager/MFHUDManager.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MFNetworkManager/MFNetworkManager.h>
#import <MJRefresh.h>
#import <YYWebImage.h>
#import <FreeStreamer/FSAudioStream.h>
#import "GODMusicModel.h"
#import "GODMusicTableViewCell.h"
@interface GODMusicViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MFNetworkManagerDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *musicList;
@property (nonatomic, assign) BOOL listEmpty;
@property (nonatomic, assign) BOOL shouldDisplay;
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, assign) NSInteger playId;
@end

@implementation GODMusicViewController

- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        _audioStream = [[FSAudioStream alloc] init];
    }
    return _audioStream;
}

- (NSMutableArray *)musicList {
    if (!_musicList) {
        _musicList = @[].mutableCopy;
    }
    return _musicList;
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
    }
    return _tableView;
}

- (void)networkManager:(MFNetworkManager *)manager didConnectedWithPrompt:(NSString *)prompt {
    if (![MFHUDManager isShowing]) {
        [MFHUDManager showWarning:prompt];
    }
    if (!self.musicList.count) {
        self.shouldDisplay = YES;
        [self.tableView reloadData];
        [self sendFirstRequest];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"iosAllNotes_24x24_"];
        UIImage *selectedImage = [[UIImage imageNamed:@"iosAllNotesS_24x24_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Music" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MFNETWROK.delegate = self;
    self.playId = -1;
    self.title = @"Music";
    self.view.backgroundColor = [UIColor whiteColor];
    self.shouldDisplay = YES;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self sendFirstRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
}

- (void)sendFirstRequest {
    [MFNETWROK get:@"music" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"success");
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in result) {
            GODMusicModel *model = [GODMusicModel yy_modelWithJSON:dic];
            [list addObject:model];
        }
        if (list.count) {
            if (self.musicList.count) {
                [self.musicList removeAllObjects];
            }
            [self.musicList addObjectsFromArray:list];
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
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GODMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    if (!cell) {
        cell = [[GODMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"music"];
    }
    GODMusicModel *model = self.musicList[indexPath.row];
    [self configCell:cell withModel:model];
    return cell;
    
}

- (void)configCell:(GODMusicTableViewCell *)cell withModel:(GODMusicModel *)model {
    [cell.playButton addTarget:self action:@selector(cellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.musicImageView yy_setImageWithURL:[NSURL URLWithString:model.thumb] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    cell.titleLabel.text = model.title;
    cell.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", model.music_duration/60, model.music_duration%60];
    if (model.isPlaying) {
        [cell.playButton setImage:[UIImage imageNamed:@"icon-player-pause-button"] forState:UIControlStateNormal];
    }else {
        [cell.playButton setImage:[UIImage imageNamed:@"icon-player-play-button"] forState:UIControlStateNormal];
    }
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.summary];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.summary length])];
    
    cell.summaryLabel.attributedText = attributedString;
    cell.artistLabel.text = model.artist;
}

- (void)cellButtonTouchUpInside:(UIButton *)sender {
    GODMusicTableViewCell *cell = (GODMusicTableViewCell *)sender.superview.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GODMusicModel *model = self.musicList[indexPath.row];
    
    
    if (self.playId == model.id) {
        [self.audioStream pause];
        model.isPlaying = !model.isPlaying;
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }else {
        if (self.audioStream.isPlaying) {
            for (NSInteger i = 0; i < self.musicList.count; i++) {
                GODMusicModel *model = self.musicList[i];
                if (model.id == self.playId) {
                    model.isPlaying = NO;
                    [UIView performWithoutAnimation:^{
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                    break;
                }
            }
            [self.audioStream stop];
        }
        

        __weak __typeof(self)weakSelf = self;
        self.audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.playId = -1;
            [strongSelf.audioStream stop];
            model.isPlaying = NO;
            [UIView performWithoutAnimation:^{
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        };
        // 播放完成的回调
        self.audioStream.onCompletion=^(){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.playId = -1;
            [strongSelf.audioStream stop];
            model.isPlaying = NO;
            [UIView performWithoutAnimation:^{
                [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        };
        // 使用音频链接URL播放音频
        NSURL *url = [NSURL URLWithString:model.music_url];

        [self.audioStream playFromURL:url];
        model.isPlaying = YES;
        self.playId = model.id;
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
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
