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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}
- (void)setupUI {
    
    self.tableNode.view.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerHeaderRefresh)];
    self.tableNode.view.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewDidTriggerFooterRefresh)];
    
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self loadData:NO];
}

- (void)tableViewDidTriggerHeaderRefresh {
    [self loadData:NO];
}

- (void)tableViewDidTriggerFooterRefresh {
    [self loadData:YES];
}


- (void)loadData:(BOOL)isAdd {
    [MFHUDManager showLoading:@"加载中"];
    [MFNETWROK post:@"user/comments" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        NSArray <GODDynamicModel *>*modelArray = [NSArray yy_modelArrayWithClass:GODDynamicModel.class json:result];
        if (!isAdd) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:modelArray];
        [self.tableNode reloadData];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
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
