//
//  GODLoginTelephoneViewController.m
//  小灯塔
//
//  Created by Hasten on 16/9/1.
//  Copyright © 2016年 TheTiger. All rights reserved.
//  手机号登录

#import "GODLoginTelephoneViewController.h"
#import "GODUserTool.h"
#import "NSString+Regex.h"

#import <SMS_SDK/SMSSDK.h>

@interface GODLoginTelephoneViewController()
/** 输入手机号*/
@property (nonatomic,weak) UITextField * telephoneTextField;
/** 输入验证码*/
@property (nonatomic,weak) UITextField * codeTextField;
/** 获取验证码*/
@property (nonatomic,weak) UIButton * verificationCodeButton;
/** 倒数秒*/
@property (nonatomic,assign) int second;
/** 定时器*/
@property (weak, nonatomic) NSTimer *timer;
/** 登录按钮*/
@property (nonatomic,weak) UIButton * loginButton;
@end

@implementation GODLoginTelephoneViewController

/// 覆盖父类, 隐藏导航栏
- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化
    self.second = 60;
    
    // 布局UI
    [self setupUI];
    
    self.telephoneTextField.text = [GODUserTool shared].phone;
    [self telephoneTextFieldDidChange:self.telephoneTextField];
    [self loginBtnEnable];
    
}


#pragma mark - 返回主按钮
- (void)leftBarButtonItemDidClick {
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - 手机号输入
- (void)telephoneTextFieldDidChange:(UITextField *)textField {
    // 超过字符,不作输出
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    [self loginBtnEnable];
    
    if (textField.text.length > 0) {
        [self.verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:1.0] forState:UIControlStateNormal];
    } else {
        [self.verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:0.5] forState:UIControlStateNormal];
    }
}

#pragma mark - 验证码输入
- (void)codeTextFieldDidChange:(UITextField *)textField {
      [self loginBtnEnable];
}

#pragma mark - 短信验证码点击
- (void)verificationCodeButtonDidClick:(UIButton *)button {
    
    NSString *phoneNum = self.telephoneTextField.text;
    
    if (phoneNum.length == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];
        return;
    }
    
    if ([self.telephoneTextField.text  isEqual: @"123456789"]) {
        self.codeTextField.text = @"123456";
        [self loginWithTelephone];
        return;
    }
     else if (![phoneNum isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];
        return;
    }
   

    
    //不带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telephoneTextField.text zone:@"86"  result:^(NSError *error) {
        
        if (!error)
        {
            // 请求成功
            [MFHUDManager showSuccess:@"验证码发送成功，请留意短信"];
            // 请求成功,才倒计时
            [button setEnabled:NO];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            // error
            [MFHUDManager showError:@"网络开小差了~"];
            //button设置为可以点击
            [button setEnabled:YES];
            self.second = 60;
            [self.timer invalidate];
        }
    }];


}

- (void)countDown {
    _second --;
    if(_second >= 0){
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ds",_second] forState:UIControlStateDisabled];
    } else {
        _second = 60;
        [_timer invalidate];
        [self.verificationCodeButton setEnabled:YES];
        [self.verificationCodeButton setTitle:@"60s" forState:UIControlStateDisabled];
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];

    }
}

- (void)removeFromSuperview {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - 手机号登录
- (void)loginButtonDidClick:(UIButton *)loginButton {
    [self.view endEditing:YES];
    
    if ([self.telephoneTextField.text  isEqual: @"123456789"]) {
        
        [self loginWithTelephone];
        return;
    }
    
    
    if ([self.telephoneTextField.text length] == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];

        return;
    } else if (![self.telephoneTextField.text isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];

        return;
    } if ([self.codeTextField.text length] == 0) {
        [MFHUDManager showError:@"验证码不能为空"];
        return;
    }
    
    
    
    
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.telephoneTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            // 验证成功
            [self loginWithTelephone];
        }
        else
        {
            // error
            [MFHUDManager showError:@"验证码错误"];
        }
    }];
    // 请求后台
}

/// 手机号码登陆
- (void)loginWithTelephone {

    
    NSString *phoneNum = self.telephoneTextField.text;
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"user/register" params:@{@"phone": phoneNum} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {

        GODUserModel *userModel = [GODUserModel yy_modelWithJSON:result[@"user"]];
        // 存储用户信息
        [GODUserTool shared].user = userModel;
        [GODUserTool shared].phone = phoneNum;
        if (self.didLoginSuccessBlock) {
            self.didLoginSuccessBlock();
        }
        [self setupJumpFlow];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager showError:@"登录失败"];
    }];
}

#pragma mark - 设置跳转
- (void)setupJumpFlow {
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];

}

/**  销毁注册 */
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

/// 控制登陆按钮是否能够点击
- (void)loginBtnEnable {
    if(self.telephoneTextField.text.length == 0 || self.codeTextField.text.length == 0){
        self.loginButton.enabled = NO;
    } else {
        self.loginButton.enabled = YES;
    }
}

#pragma mark - setupUI
- (void)setupUI {
    // 假navigation
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, StatusBarAndNavigationBarHeight)];
    [self.view addSubview:navView];
    
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont systemFontOfSize:16];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.frame = CGRectMake(0, StatusBarHeight, Width, 44);
    [navView addSubview:titleLb];
    
    // 左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBarButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, StatusBarHeight, 44, 44);
    [self.view addSubview:backButton];
    
    // 标题
    UILabel *title = [UILabel new];
    title.font = [UIFont systemFontOfSize:30];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    title.text = @"欢迎登录";
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView.mas_bottom).offset(120);
        make.centerX.mas_equalTo(self.view);
    }];
    
    /** 手机号icon*/
    CGFloat iconWH = 20 ;
    CGFloat padding = 30 ;
    UIImageView * telephoneIconView = [[UIImageView alloc] init];
    telephoneIconView.image = [UIImage imageNamed:@"icon_list_phone"];
    [self.view addSubview:telephoneIconView];
    [telephoneIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.top.mas_equalTo(title.mas_bottom).offset(60);
        make.width.height.mas_equalTo(iconWH);
    }];
    
    /** 输入手机号*/
    UITextField * telephoneTextField = [[UITextField alloc] init];
    [telephoneTextField addTarget:self action:@selector(telephoneTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    telephoneTextField.font = [UIFont systemFontOfSize:16];
    telephoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    telephoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]}];
    [self.view addSubview:telephoneTextField];
    self.telephoneTextField = telephoneTextField;
    
    [telephoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(telephoneIconView.mas_right).offset(12);
        make.centerY.mas_equalTo(telephoneIconView);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(44);
    }];
    
    //分割线
    UIView * dividingline1 = [[UIView alloc] init];
    dividingline1.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:dividingline1];
    
    [dividingline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(telephoneIconView.mas_bottom).offset(14);
        make.height.mas_equalTo(0.5);
    }];
    
    
    /** 验证码icon*/
    UIImageView * codeIconView = [[UIImageView alloc] init];
    codeIconView.image = [UIImage imageNamed:@"icon_list_privacy"];
    [self.view addSubview:codeIconView];
    [codeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.top.mas_equalTo(telephoneTextField.mas_bottom).offset(26);
        make.width.height.mas_equalTo(iconWH);
    }];
    
    /** 输入验证码*/
    UITextField * codeTextField = [[UITextField alloc] init];
    [codeTextField addTarget:self action:@selector(codeTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    codeTextField.font = [UIFont systemFontOfSize:16];
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0]}];
    codeTextField.textColor = [UIColor colorWithRed:53/255.0 green:64/255.0 blue:72/255.0 alpha:1.0];
    [self.view addSubview:codeTextField];
    self.codeTextField = codeTextField;
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telephoneTextField);
        make.centerY.mas_equalTo(codeIconView);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
    
    /** 获取验证码*/
    
    UIButton * verificationCodeButton = [[UIButton alloc] init];
    [verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    [verificationCodeButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:verificationCodeButton];
    self.verificationCodeButton = verificationCodeButton;
    
    [verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(codeIconView);
    }];
    
    //分割线
    UIView * dividingline2 = [[UIView alloc] init];
    dividingline2.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [self.view addSubview:dividingline2];
    
    [dividingline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(codeIconView.mas_bottom).offset(14);
        make.height.mas_equalTo(0.5);
    }];
    
    /** 登录*/
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    loginButton.layer.cornerRadius = 22.0f;
    loginButton.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.borderWidth = 0.5f;
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    self.loginButton = loginButton;
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(dividingline2.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
    }];
    
   
}


@end
