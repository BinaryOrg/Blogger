//
//  GODDynamicController.m
//  Blogger
//
//  Created by Maker on 2019/1/20.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicController.h"
#import <MJRefresh.h>
#import "GODDynamicCellNode.h"

@interface GODDynamicController ()<ASTableDelegate, ASTableDataSource, GODDynamicCellNodeDelegate>
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation GODDynamicController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"iosAllNotes_24x24_"];
        UIImage *selectedImage = [[UIImage imageNamed:@"iosAllNotesS_24x24_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"oppions" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"oppinions";
    [self setupUI];
    
    GODUserModel *user = [[GODUserModel alloc] init];
    user.username = @"测试";
    user.avatar = @"http://a3.att.hudong.com/58/63/01300542846491148697637760361.jpg";
    user.phone = @"199999999";
    
    GODDynamicModel *model = [[GODDynamicModel alloc] init];
    model.isFavor = YES;
    model.favorTotal = 200000;
    model.releaseuser = user;
    model.content = @"家时空裂缝假按揭佛我进去偶家卧佛寺 安徽省飞机返回去维护佛七哈佛千万按时发生开发好看是否";
    
    [self.dataList addObject:model];
    [self.tableNode reloadData];
//    [self loadData:NO];

}
- (void)setupUI {
    
    self.tableNode.view.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
    self.tableNode.view.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
    
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NavigationBarHeight);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    
}

- (void)tableViewDidTriggerHeaderRefresh {
    [self loadData:NO];
}

- (void)tableViewDidTriggerFooterRefresh {
    [self loadData:YES];
}


- (void)loadData:(BOOL)isAdd {
    [MFHUDManager showLoading:@"加载中"];
    [MFNETWROK get:@"user/comments" params:@{@"index" : [NSString stringWithFormat:@"%ld", (self.dataList.count / 10) + 1]} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        [self.tableNode.view.mj_header endRefreshing];
        [self.tableNode.view.mj_footer endRefreshing];
        NSArray <GODDynamicModel *>*modelArray = [NSArray yy_modelArrayWithClass:GODDynamicModel.class json:result];
        if (!isAdd) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:modelArray];
        [self.tableNode reloadData];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self.tableNode.view.mj_header endRefreshing];
        [self.tableNode.view.mj_footer endRefreshing];
        [MFHUDManager dismiss];
        [MFHUDManager showError:@"登录失败"];
    }];
}

//点赞
- (void)clickEnjoyWithNode:(GODDynamicCellNode *)cellNode {
    
    
    
}

#pragma mark - tableViewDataSourceAndDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        GODDynamicModel *model = self.dataList[indexPath.row];
        GODDynamicCellNode *node = [[GODDynamicCellNode alloc] initWithModel:model];;
        node.delegate = self;
        
        return node;
        
    };
    
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableNode.backgroundColor = [UIColor whiteColor];
        _tableNode.view.estimatedRowHeight = 0;
        _tableNode.leadingScreensForBatching = 1.0;
        _tableNode.contentInset = UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0);
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableNode;
}

-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
