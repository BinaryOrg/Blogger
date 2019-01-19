//
//  GODTextView.m
//  小灯塔
//
//  Created by MakerYang on 2018/3/16.
//  Copyright © 2018年 TheTiger. All rights reserved.
//

#import "GODTextView.h"
#define INT_LONG_BASE(x) ((long)x)

#define INT_ULONG_BASE(x) ((unsigned long)x)

@interface GODTextView ()

{
    
    
    
}

@end
@implementation GODTextView
@synthesize promptLab,placehLab;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self];
    
    
}




- (void)setupUI{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditBegin:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditEnd:) name:UITextViewTextDidEndEditingNotification object:self];
    
    
    
    self.showsVerticalScrollIndicator = NO;
    
    
    
    _textLength = 1000;
    
    _interception = NO;
    
    
    
    _placehTextColor = [UIColor grayColor];
    
    _placehFont = [UIFont systemFontOfSize:14.0];
    
    _placehText = @"";
    
    
    
    _promptLabHiden = YES;
    
    _promptFrameMaxX = 10.0;
    
    _promptFrameMaxY = 10.0;
    
    _promptTextColor = GODColor(188, 188, 288);
    
    _promptFont = [UIFont systemFontOfSize:14.0];
    
    _promptBackground = self.backgroundColor;
    
    
    
    placehLab = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 200, 0)];
    
    placehLab.backgroundColor = [UIColor clearColor];
    placehLab.textColor = _placehTextColor;
    
    placehLab.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:placehLab];
    [placehLab sizeToFit];
    
    
    if (_promptLabHiden) {//初始界面加入右下角字数提示语句，开始编辑时需要删除，因为textview_scrollview上加载的视图会跟随画布移动
        
        promptLab = [[UILabel alloc] init];
        
        promptLab.backgroundColor = [UIColor clearColor];
        
        promptLab.font = _promptFont;
        
        promptLab.textColor = GODColor(188, 188, 188);
        
        promptLab.text = [NSString stringWithFormat:@"0/%ld",_textLength];
        
        [promptLab sizeToFit];
        
        promptLab.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetHeight(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
        
        [self addSubview:promptLab];
        
    }
    
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, CGRectGetHeight(promptLab.frame)+_promptFrameMaxY, self.contentInset.right);

}


#pragma mark <--------------self_text_set-------------->

- (void)setTextLength:(NSInteger)textLength{
    
    _textLength = textLength;
    
    
    
    promptLab.text = [NSString stringWithFormat:@"0/%ld",_textLength];
    
    [promptLab sizeToFit];
    
    promptLab.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetHeight(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
    
    
    
    self.scrollEnabled = NO;
    
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, CGRectGetHeight(promptLab.frame)+_promptFrameMaxY+20, self.contentInset.right);
    
}


#pragma mark <--------------placehLab_set-------------->

- (void)setPlacehTextColor:(UIColor *)placehTextColor{
    
    _placehTextColor = placehTextColor;
    
    placehLab.textColor = _placehTextColor;
    
}

- (void)setPlacehFont:(UIFont *)placehFont{
    
    _placehFont = placehFont;
    
    placehLab.font = _placehFont;
    
}

- (void)setPlacehText:(NSString *)placehText{
    
    _placehText = placehText;
    
    placehLab.text = _placehText;
    
    [placehLab sizeToFit];
    
}


#pragma mark <--------------promptLab_set-------------->

- (void)setPromptFrameMaxX:(CGFloat)promptFrameMaxX{
    
    _promptFrameMaxX = promptFrameMaxX;
    
    promptLab.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetHeight(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
    
}

- (void)setPromptFrameMaxY:(CGFloat)promptFrameMaxY{
    
    _promptFrameMaxY = promptFrameMaxY;
    
    promptLab.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetHeight(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
    
}

- (void)setPromptTextColor:(UIColor *)promptTextColor{
    
    _promptTextColor = promptTextColor;
    
    promptLab.textColor =  GODColor(188, 188, 188);;
    
}

- (void)setPromptFont:(UIFont *)promptFont{
    
    _promptFont = promptFont;
    
    promptLab.font = _promptFont;
    
    [promptLab sizeToFit];
    
    promptLab.frame = CGRectMake(CGRectGetWidth(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetHeight(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
    
}

- (void)setPromptBackground:(UIColor *)promptBackground{
    
    _promptBackground = promptBackground;
    
    promptLab.backgroundColor = _promptBackground;
    
}


#pragma mark <--------------textView_通知监听-------------->

- (void)textViewEditBegin:(NSNotification *)obj{//编辑开始
    
    if (_promptLabHiden && [[promptLab superview] isKindOfClass:[self class]] && promptLab) {
        
        [promptLab removeFromSuperview];//删除旧的初始界面右下角字数提示语句父视图是（self），开始编辑时需要删除，因为textview_scrollview上加载的视图会跟随画布移动
        
        
        
        self.scrollEnabled = YES;
        
        
        
        //新的右下角字数提示语句
        
        promptLab = [[UILabel alloc] init];
        
        promptLab.backgroundColor = self.backgroundColor;
        
        promptLab.font = _promptFont;
        
        promptLab.textColor = GODColor(188, 188, 188);
        
        promptLab.text = [NSString stringWithFormat:@"%ld/%ld",self.text.length,_textLength];
        
        [promptLab sizeToFit];
        
        promptLab.frame = CGRectMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetMaxY(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
        
        
        
        //底部的遮罩图
//        
//        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - CGRectGetHeight(promptLab.frame) - _promptFrameMaxY, CGRectGetWidth(self.frame), CGRectGetHeight(promptLab.frame) + _promptFrameMaxY)];
//
//        whiteView.backgroundColor = self.backgroundColor;
//
//
//
//        [[self superview] addSubview:whiteView];//父视图切换为[self superview],防止跟随付self.scrollview的画布滚动
        
        [[self superview] addSubview:promptLab];//父视图切换为[self superview],防止跟随付self.scrollview的画布滚动
        
    }
    
}

- (void)textViewEditEnd:(NSNotification *)obj{//编辑结束
    
    
    
}

-(void)textViewEditChanged:(NSNotification *)obj{//编辑中
    
    if (self.text.length == 0) {
        
        placehLab.hidden = NO;
        
    }else{
        
        placehLab.hidden = YES;

    }
    
    
    
    NSString *toBeString = self.text;
    
    NSString *primaryLanguageStr = self.textInputMode.primaryLanguage; // 键盘输入模式
    
    if ([primaryLanguageStr isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [self markedTextRange];
        
        //获取高亮部分
        
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        
        if (!position) {
            
            if (toBeString.length > _textLength) {
                
                if (_interception) {
                    
                    self.text = [toBeString substringToIndex:_textLength];
                    
                }else{
                    
                    
                    
                }
                
                [self changePromptLab];
                
            }else{
                
                [self changePromptLab];
                
            }
            
        }else{
            
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{
        
        //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > _textLength) {
            
            if (_interception) {
                
                self.text = [toBeString substringToIndex:_textLength];
                
            }else{
                
                
                
            }
            
            [self changePromptLab];
            
        }else{
            
            [self changePromptLab];
            
        }
        
    }
    
    
    
    if (self.EditChangedBlock) {//一个词语输出监听
        
        self.EditChangedBlock(self.text);
        
    }
    
}

- (void)changePromptLab{
    
    
    
    NSString *changeStr = [NSString stringWithFormat:@"%ld/%ld",self.text.length,_textLength];
    
    if (!_interception && (self.text.length > _textLength)) {
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:changeStr];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:GODColor(215,171,112) range:NSMakeRange(0, changeStr.length - [NSString stringWithFormat:@"%ld",_textLength].length)];
        
        promptLab.attributedText = attributedStr;
        
    }else{
        
        promptLab.text = changeStr;
        NSString *temp =[NSString stringWithFormat:@"%ld",self.text.length];
        NSString *temp_second =[NSString stringWithFormat:@"%ld",_textLength];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:changeStr];
        [att addAttribute:NSForegroundColorAttributeName value:GODColor(215,171,112) range:NSMakeRange(0, temp.length)];
         [att addAttribute:NSForegroundColorAttributeName value:GODColor(188,188,188) range:NSMakeRange(temp.length+1, temp_second.length)];
        promptLab.attributedText = att;
    }


    [promptLab sizeToFit];
    
    promptLab.frame = CGRectMake(CGRectGetMaxX(self.frame)-CGRectGetWidth(promptLab.frame)-_promptFrameMaxX, CGRectGetMaxY(self.frame)-CGRectGetHeight(promptLab.frame)-_promptFrameMaxY - 10, CGRectGetWidth(promptLab.frame), CGRectGetHeight(promptLab.frame));
    
}

/*
 
 // Only override drawRect: if you perform custom drawing.
 
 // An empty implementation adversely affects performance during animation.
 
 - (void)drawRect:(CGRect)rect {
 
 // Drawing code
 
 }
 
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
