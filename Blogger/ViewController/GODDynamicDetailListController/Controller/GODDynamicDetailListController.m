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
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    GODDynamicModel *model = self.model;
    GODDynamicCommentNode *node = [[GODDynamicCommentNode alloc] initWithModel:model];
    node.neverShowPlaceholders = YES;
    node.delegate = self;
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
    NSLog(@"%ld", (long)node.model.like_count);
}

//- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return ^ASCellNode *() {
//
//    };
//
//}

@end
