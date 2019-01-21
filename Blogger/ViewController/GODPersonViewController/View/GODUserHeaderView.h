//
//  GODUserHeaderView.h
//  Blogger
//
//  Created by Maker on 2019/1/21.
//  Copyright © 2019 GodzzZZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GODUserHeaderView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, copy) void(^clickLogBtn) (void);
@property (nonatomic, copy) void(^clickUserIcon) (void);
@property (nonatomic, copy) void(^clickUserName) (void);

@end

NS_ASSUME_NONNULL_END
