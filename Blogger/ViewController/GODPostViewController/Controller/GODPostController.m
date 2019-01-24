//
//  GODPostController.m
//  按钮测试
//
//  Created by Maker on 2019/1/19.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "GODPostController.h"
#import "GODTextView.h"

@interface GODPostController ()

@property (nonatomic, strong) GODTextView *textView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation GODPostController

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
        [MFHUDManager showWarning:@"请输入内容"];
    }else {
        [MFHUDManager showLoading:@"发布中"];
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"user/comment" params:@{@"content" : self.textView.text, @"phone" : [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            NSLog(@"%@", result);
            [MFHUDManager dismiss];
            if ([result[@"code"] integerValue] == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [MFHUDManager showError:@"发布失败"];
            }
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            
            [MFHUDManager dismiss];
            [MFHUDManager showError:@"发布失败"];
        }];
    }
}



-(UILabel *)titleLb {
    if (!_titleLb) {
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.text = @"发布内容";
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

-(GODTextView *)textView {
    if (!_textView) {
        _textView = [[GODTextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 160)];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 5, 0, 5);
        _textView.interception = YES;
        _textView.placehText = @"说说你的想法";
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placehLab.font = [UIFont systemFontOfSize:16];
        _textView.promptFrameMaxY = 0;
        _textView.promptTextColor = GODColor(188, 188, 188);
        _textView.placehLab.frame = CGRectMake(10, 17, 200, 16);
    }
    return _textView;
}

@end
