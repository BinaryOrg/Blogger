//
//  GODDynamicDetailListController.m
//  Blogger
//
//  Created by 张冬冬 on 2019/1/23.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODDynamicDetailListController.h"
#import "GODDynamicCommentNode.h"
#import "GODLoginTelephoneViewController.h"
#import "GODAppendViewController.h"
#import "GODDynamicDetailNode.h"

#define AUTO_TAIL_LOADING_NUM_SCREENFULS  2.5
@interface GODDynamicDetailListController ()<ASTableDelegate, ASTableDataSource, GODDynamicCommentNodeDelegate>
@property (nonatomic, strong) ASTableNode *tableNode;
@property(nonatomic, strong) NSMutableArray *dataList;
@end

@implementation GODDynamicDetailListController

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = @[].mutableCopy;
    }
    return _dataList;
}

- (instancetype)init {
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    self = [super initWithNode:_tableNode];
    if (self) {
        self.title = @"详情";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.tableNode.leadingScreensForBatching = AUTO_TAIL_LOADING_NUM_SCREENFULS;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.node addSubnode:self.tableNode];
    [self loadData];
}

- (void)loadData {
    [MFHUDManager showLoading:@"加载中"];
    [MFNETWROK get:[NSString stringWithFormat:@"user/appends?commentId=%@", @(self.model.id)] params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"%@", result);
        [MFHUDManager dismiss];
        NSMutableArray *list = @[].mutableCopy;
        for (NSDictionary *dic in result) {
            GODDetailModel *model = [GODDetailModel yy_modelWithJSON:dic];
            [list addObject:model];
        }
        [list sortUsingComparator:^NSComparisonResult(GODDetailModel *obj1, GODDetailModel *obj2) {
            return obj1.date < obj2.date;
        }];
        [self.dataList addObjectsFromArray:list];
        [self.tableNode reloadData];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        NSLog(@"%@", error.userInfo);
        [MFHUDManager dismiss];
    }];
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 1 + self.dataList.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GODDynamicModel *model = self.model;
        GODDynamicCommentNode *node = [[GODDynamicCommentNode alloc] initWithModel:model];
        node.neverShowPlaceholders = YES;
        node.delegate = self;
        return node;
    }
    GODDetailModel *model = self.dataList[indexPath.row - 1];
    GODDynamicDetailNode *node = [[GODDynamicDetailNode alloc] initWithModel:model];
    return node;
}

- (void)clickLikeButton:(GODDynamicCommentNode *)node {
    if ([GODUserTool shared].user.id.length == 0) {//没有登录
        [self presentViewController:[[GODLoginTelephoneViewController alloc] init] animated:YES completion:nil];
    }else {
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"user/like" params:@{@"comment_id" : @(node.model.id), @"phone" : [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            [MFHUDManager dismiss];
            
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            
        }];
    }
}

- (void)clickCommentButton:(GODDynamicCommentNode *)node {
    if ([GODUserTool shared].user.id.length == 0) {//没有登录
        [self presentViewController:[[GODLoginTelephoneViewController alloc] init] animated:YES completion:nil];
    }else {
        GODAppendViewController *vc = [[GODAppendViewController alloc] init];
        vc.commentId = node.model.id;
        vc.returnModel = ^(GODDetailModel *model) {
            [self.dataList insertObject:model atIndex:0];
            [self.tableNode reloadData];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
