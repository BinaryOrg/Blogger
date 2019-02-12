//
//  GODPostController.m
//  Blogger
//
//  Created by Maker on 2019/2/12.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODPostController.h"
#import "GODNotification.h"

@interface GODPostController ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation GODPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"发布";
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"发布" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickPost) forControlEvents:UIControlEventTouchUpInside];
    [nextButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
    [self.view addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
}


- (void)clickPost {
    if (self.textView.text.length == 0) {
        [MFHUDManager showWarning:@"请输入内容"];
    }else {
        [MFHUDManager showLoading:@"发布中"];
        MFNETWROK.requestSerialization = MFJSONRequestSerialization;
        [MFNETWROK post:@"user/comment" params:@{@"content" : self.textView.text, @"phone" : [GODUserTool shared].phone.length ? [GODUserTool shared].phone : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            NSLog(@"%@", result);
            [MFHUDManager dismiss];
            if ([result[@"code"] integerValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:GODCommentLikeNotification object:nil];
                });
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [MFHUDManager showError:@"发布失败"];
            }
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            
            [MFHUDManager dismiss];
            [MFHUDManager showError:@"发布失败"];
        }];
    }
    
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
