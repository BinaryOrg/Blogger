//
//  GODLoginTelephoneViewController.h
//  小灯塔
//
//  Created by Hasten on 16/9/1.
//  Copyright © 2016年 Maker. All rights reserved.
//  手机号登录

#import <UIKit/UIKit.h>
@interface GODLoginTelephoneViewController : UIViewController

@property (nonatomic, copy) void(^didLoginSuccessBlock) (void);

@end
