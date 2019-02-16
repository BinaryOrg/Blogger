//
//  GODAppendViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/23.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODAppendViewController.h"
@interface GODAppendViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation GODAppendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupUI {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(SafeAreaTopHeight+20);
        make.height.mas_equalTo(44);
    }];
    
    
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 44));
    }];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLb);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(35, 44));
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitBtn.mas_bottom).mas_equalTo(12);
        make.bottom.left.right.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.textView];
    
    
}


//取消
- (void)clickCancel {
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发布
- (void)clickSubmit {
    if (self.textView.text.length == 0) {
        [MFHUDManager showWarning:@"请输入回复内容"];
    }else {
        [MFHUDManager showLoading:@"回复中"];
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"user/append" params:@{ @"commentId": @(self.commentId), @"append" : self.textView.text, @"phone" : [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            NSLog(@"%@", result);
            [MFHUDManager dismiss];
            if ([result[@"code"] integerValue] == 0) {
                GODDetailModel *model = [GODDetailModel yy_modelWithJSON:result[@"appendCommentDto"]];
                self.returnModel(model);
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [MFHUDManager showError:@"回复失败"];
            }
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            
            [MFHUDManager dismiss];
            [MFHUDManager showError:@"回复失败"];
        }];
    }
}



-(UILabel *)titleLb {
    if (!_titleLb) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = @"回复内容";
        titleLb.textColor = GODColor(53,64,72);
        titleLb.font = [UIFont systemFontOfSize:17];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb = titleLb;
    }
    return _titleLb;
}

-(UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:GODColor(102,102,102) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = cancelBtn;
    }
    return _cancelBtn;
}

-(UIButton *)submitBtn {
    if (!_submitBtn) {
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setTitle:@"发布" forState:UIControlStateNormal];
        submitBtn.titleLabel.font =  [UIFont systemFontOfSize:16];
        [submitBtn setTitleColor:GODColor(215,171,112) forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn = submitBtn;
    }
    return _submitBtn;
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceVertical = YES;
        scrollView.showsVerticalScrollIndicator  = NO;
        _scrollView = scrollView;
        
    }
    return _scrollView;
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 160)];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 5, 0, 5);
        _textView.font = [UIFont systemFontOfSize:16];
   
    }
    return _textView;
}

@end
