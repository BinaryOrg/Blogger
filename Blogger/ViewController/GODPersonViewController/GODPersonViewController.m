//
//  GODPersonViewController.m
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "GODPersonViewController.h"
#import <YYCache.h>
#import <MFHUDManager.h>
#import <StoreKit/StoreKit.h>
#import <YYWebImage/YYWebImage.h>
#import "UIColor+CustomColors.h"
#import "GODAvatarTableViewCell.h"
#import "GODConfigurationTableViewCell.h"
#import "GODScoreViewController.h"
#import "GODPostController.h"
#import "GODLoginTelephoneViewController.h"
#import "GODUserHeaderView.h"
#import <QMUIKit.h>
#import "GODSDKConfigKey.h"
@interface GODPersonViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SKStoreProductViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) GODAvatarTableViewCell *avatarCell;
@property (nonatomic ,strong) NSArray *textList;
@property(nonatomic, strong) GODUserHeaderView *header;
@end

@implementation GODPersonViewController

- (NSArray *)textList {
    if (!_textList) {
        _textList = @[
                      @"清除缓存",
                      @"用户评价",
                      @"联系作者",
                      @"发布内容",
                      ];
    }
    return _textList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"tab_buddy_nor"];
        UIImage *selectedImage = [[UIImage imageNamed:@"tab_buddy_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:image selectedImage:selectedImage];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self addHeaderView];
}

- (void)addHeaderView {
    self.header = [[GODUserHeaderView alloc] init];
    self.header.frame = CGRectMake(0, 0, Width, 120);
    __weak typeof(self)weakSelf = self;
    //点击登录
    self.header.clickLogBtn = ^{
        GODLoginTelephoneViewController *vc = [[GODLoginTelephoneViewController alloc] init];
        [weakSelf presentViewController:vc animated:YES completion:nil];
        vc.didLoginSuccessBlock = ^{
            [weakSelf addHeaderView];
        };
    };
    __weak __typeof(self.header)weakHeader = self.header;
    self.header.clickUserName = ^{
        __strong __typeof(weakHeader)strongHeader = weakHeader;
        if (![QMUIAlertController isAnyAlertControllerVisible]) {
            
            QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"请输入修改成的用户名" preferredStyle:QMUIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(QMUITextField *textField) {
                textField.placeholder = @"请输入新用户名";
//                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            
            QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                NSString *userName = aAlertController.textFields.firstObject.text;
                if (!userName) {
                    [MFHUDManager showError:[NSString stringWithFormat:@"请输入合法用户名"]];
                    return;
                }
                
                MFNETWROK.requestSerialization = MFJSONRequestSerialization;
                [MFNETWROK post:@"user/username" params:@{
                                                          @"phone":[GODUserTool shared].phone,
                                                          @"username": userName
                                                          } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                              NSLog(@"%@", result);
                                                              if (![result[@"code"] integerValue]) {
                                                                  GODUserModel *newUser = [GODUserModel yy_modelWithJSON:result[@"user"]];
                                                                  [MFHUDManager showSuccess:@"修改成功!"];
                                                                  [GODUserTool shared].user = newUser;
                                                             [strongHeader.btn setTitle:userName forState:UIControlStateNormal];
                                                              }else {
                                                                  [MFHUDManager showError:@"修改失败~"];
                                                                 
                                                              }
                                                          } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                              [MFHUDManager showError:@"修改失败~"];
                                                          }];
            }];
            
            
            
            QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [alert showWithAnimated:YES];
        }
    };
    //点击用户头像
    self.header.clickUserIcon = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = strongSelf;
        [strongSelf presentViewController:picker animated:YES completion:nil];
    };
    self.tableView.tableHeaderView = self.header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    GODConfigurationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GODConfigurationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",@(indexPath.row+1)]];
    cell.label.text = self.textList[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self presentViewController:[[GODScoreViewController alloc] init] animated:YES completion:nil];
    }
    else if (indexPath.row == 2) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"Shmily_liuyy";
        [MFHUDManager showSuccess:@"作者微信号已成功复制到剪切板！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:@"weixin://"];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        });
    }
    else if (indexPath.row == 3) {
        if ([GODUserTool shared].user.id.length == 0) {//没有登录
            GODLoginTelephoneViewController *vc = [[GODLoginTelephoneViewController alloc] init];
            vc.didLoginSuccessBlock = ^{
                [self addHeaderView];
            };
            [self presentViewController:vc animated:YES completion:nil];
        }else {
            [self.navigationController pushViewController:[[GODPostController alloc] init] animated:YES];
        }
    }
    else {
        [[GODUserTool shared] clearUserInfo];
        [self addHeaderView];
        if ([MFHUDManager isShowing]) {
            return;
        }else {
            [[YYImageCache sharedCache].diskCache removeAllObjects];
            [[YYImageCache sharedCache].memoryCache removeAllObjects];
            
            [MFHUDManager showLoading:@"正在清除..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MFHUDManager showSuccess:@"清除成功!"];
            });
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
       //上传
        [MFHUDManager showLoading:@"上传中..."];
        NSString *phone = [GODUserTool shared].phone;
        [MFNETWROK upload:[NSString stringWithFormat:@"user/avatar?phone=%@", phone] params:nil name:@"avatar" images:@[image] imageScale:0.8 imageType:MFImageTypePNG progress:^(NSProgress *progress) {
            
        } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            if (![result[@"code"] integerValue]) {
                GODUserModel *newUser = [GODUserModel yy_modelWithJSON:result[@"user"]];
                [MFHUDManager showSuccess:@"修改成功!"];
                [GODUserTool shared].user = newUser;
                NSLog(@"%@", result);
                NSLog(@"%@", [NSString stringWithFormat:@"%@%@", BASE_URL, newUser.avatar]);
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_AVATAR_URL, newUser.avatar]];
                [self.header.imgView yy_setImageWithURL:url placeholder:[UIImage imageNamed:@""]];
            }else {
                [MFHUDManager showError:@"修改失败~"];
                
            }
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            NSLog(@"%@", error.userInfo);
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
