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
#import <QMUIKit/QMUIKit.h>

@interface QDPopupContainerView : QMUIPopupContainerView
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger height;
@end

@implementation QDPopupContainerView

- (instancetype)initWithDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource height:(NSInteger)height {
    self = [super init];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = delegate;
        self.tableView.dataSource = dataSource;
        [self.contentView addSubview:self.tableView];
        self.height = height;
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    return self;
}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(80, self.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 所有布局都参照 contentView
    self.tableView.frame = self.contentView.bounds;
    
}
@end

@interface GODDynamicController ()
<
ASTableDelegate,
ASTableDataSource,
GODDynamicCellNodeDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) QDPopupContainerView *popupView;
@property (nonatomic, strong) NSArray *funcList;
@end

@implementation GODDynamicController

- (NSArray *)funcList {
    if (!_funcList) {
        _funcList = @[
                      @"举报"
                      ];
    }
    return _funcList;
}

- (void)setPopupViewWithHeight:(NSInteger)height targetView:(UIView *)targetView {
    self.popupView = [[QDPopupContainerView alloc] initWithDelegate:self dataSource:self height:height];
    self.popupView.maskViewBackgroundColor = UIColorMaskWhite;
    self.popupView.automaticallyHidesWhenUserTap = YES;
    [self.popupView layoutWithTargetRectInScreenCoordinate:[targetView convertRect:targetView.bounds toView:nil]];
    self.popupView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;// 默认在目标的下方，如果目标下方空间不够，会尝试放到目标上方。若上方空间也不够，则缩小自身的高度。
    self.popupView.didHideBlock = ^(BOOL hidesByUserTap) {
        
    };
    
}

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
    NSInteger index = 0;
    if (isAdd) {
        if (self.dataList.count % 10 > 0) {
            index = (self.dataList.count / 10) + 1;
        }else {
            index = self.dataList.count / 10;
        }
    }
    NSString *url = [NSString stringWithFormat:@"user/comments?phone=%@&&index=%lu", [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @"", index];
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
//操作
- (void)clickOperationWithNode:(GODDynamicCellNode *)cellNode {
    if (![QMUIAlertController isAnyAlertControllerVisible]) {
        
        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"举报" preferredStyle:QMUIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(QMUITextField *textField) {
            textField.placeholder = @"请输入举报信息";
        }];
        
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            NSString *reportText = aAlertController.textFields.firstObject.text;
            if (!reportText) {
                [MFHUDManager showError:[NSString stringWithFormat:@"请输入举报内容"]];
                return;
            }
            [MFHUDManager showSuccess:@"举报成功!"];

        }];
        
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert showWithAnimated:YES];
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
