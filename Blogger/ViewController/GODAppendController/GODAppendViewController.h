//
//  GODAppendViewController.h
//  Blogger
//
//  Created by pipelining on 2019/1/23.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GODDetailModel.h"
typedef void (^ReturnModel)(GODDetailModel *model);
@interface GODAppendViewController : UIViewController
@property(nonatomic, assign) NSInteger commentId;
@property(nonatomic, copy) ReturnModel returnModel;
@end
