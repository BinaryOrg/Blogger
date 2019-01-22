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
#import "GODPostController.h"
#import "GODLoginTelephoneViewController.h"

@interface GODDynamicController ()<ASTableDelegate, ASTableDataSource, GODDynamicCellNodeDelegate>
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation GODDynamicController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"tab_qworld_nor"];
        UIImage *selectedImage = [[UIImage imageNamed:@"tab_qworld_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态";
    [self setupUI];
    
  
    [self loadData:NO];

}
- (void)setupUI {
    
    self.tableNode.view.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
    self.tableNode.view.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
    
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NavigationBarHeight);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight - SafeTabBarHeight);
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
    NSString *url = [NSString stringWithFormat:@"user/comments?phone=%@&&index=%lu", [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @"", isAdd ? (self.dataList.count / 10) : 0];
    [MFNETWROK get:url params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        [self.tableNode.view.mj_header endRefreshing];
        [self.tableNode.view.mj_footer endRefreshing];
        NSArray <GODDynamicModel *>*modelArray = [NSArray yy_modelArrayWithClass:GODDynamicModel.class json:result[@"commentDtos"]];
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
    if ([GODUserTool shared].user.id.length == 0) {//没有登录
        [self presentViewController:[[GODLoginTelephoneViewController alloc] init] animated:YES completion:nil];
    }else {
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"user/like" params:@{@"comment_id" : @(cellNode.model.id), @"phone" : [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            [MFHUDManager dismiss];
           
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            
        }];
    }
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
