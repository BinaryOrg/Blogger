//
//  GODWebViewController.m
//  Blogger
//
//  Created by 张冬冬 on 2019/1/31.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import "GODWebViewController.h"
#import <WebKit/WebKit.h>
@interface GODWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation GODWebViewController

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"看点";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

@end
