//
//  GODTextView.h
//  小灯塔
//
//  Created by MakerYang on 2018/3/16.
//  Copyright © 2018年 TheTiger. All rights reserved.
//  输入框

#import <UIKit/UIKit.h>
typedef void (^textBlocks)(NSString *text);
@interface GODTextView : UITextView
//编辑字体个数超过限制，是否使用自动截取的方式，默认：NO
@property (nonatomic,assign) BOOL interception;
///输入字体个数最大限制个数，默认：1000
@property (nonatomic,assign) NSInteger textLength;
///默认提示lab
@property (nonatomic,strong) UILabel *placehLab;
///默认：[UIColor grayColor]
@property (nonatomic,strong) UIColor *placehTextColor;
///默认：[UIFont systemFontOfSize:14.0]
@property (nonatomic,strong) UIFont *placehFont;
///默认:@""
@property (nonatomic,strong) NSString *placehText;
///是否需要右下角文字计数显示lab，默认：YES
@property (nonatomic,assign) BOOL promptLabHiden;
///右下角文字计数显示lab
@property (nonatomic,strong) UILabel *promptLab;
///默认：[UIColor grayColor]
@property (nonatomic,strong) UIColor *promptTextColor;
///默认：[UIFont systemFontOfSize:14.0];
@property (nonatomic,strong) UIFont *promptFont;
///默认：self.backgroundColor
@property (nonatomic,strong) UIColor *promptBackground;
///右下角，文字个数提示框_距父视图右边距_默认：10
@property (nonatomic,assign) CGFloat promptFrameMaxX;
///右下角，文字个数提示框_距父视图底边距_默认：10
@property (nonatomic,assign) CGFloat promptFrameMaxY;
///一个词语输出监听
@property (nonatomic,copy) textBlocks EditChangedBlock;

- (void)setupUI;

@end
