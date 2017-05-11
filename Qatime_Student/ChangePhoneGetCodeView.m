//
//  ChangePhoneGetCodeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePhoneGetCodeView.h"

@interface ChangePhoneGetCodeView (){
    
    UILabel *_label;
    
}

@end

@implementation ChangePhoneGetCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        [self setupViews];
        
        
    }
    return self;
}

- (void)setupViews{
    
    _label = [[UILabel alloc]init];
    _label.text = @"当前绑定手机:";
    _label.textColor = [UIColor blackColor];
    [self addSubview:_label];
    _label.sd_layout
    .leftSpaceToView(self,20)
    .topSpaceToView(self,30)
    .autoHeightRatio(0);
    [_label setSingleLineAutoResizeWithMaxWidth:1000];
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.textColor = [UIColor blackColor];
    [self addSubview:_phoneLabel];
    _phoneLabel.sd_layout
    .centerXEqualToView(self)
    .topEqualToView(_label)
    .autoHeightRatio(0);
    [_phoneLabel setSingleLineAutoResizeWithMaxWidth:1000];

    UIView *text1 = [[UIView alloc]init];
    text1.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
    text1.layer.borderWidth = 1;
    text1.backgroundColor = [UIColor whiteColor];
    [self addSubview:text1];
    
    text1.sd_layout
    .leftSpaceToView(self, 30*ScrenScale)
    .widthIs((self.width_sd-60*ScrenScale)*0.6)
    .topSpaceToView(_phoneLabel, 30*ScrenScale)
    .heightIs(40*ScrenScale320);
    
    _codeText = [[UITextField alloc]init];
    _codeText.placeholder = @"输入收到的验证码";
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    [text1 addSubview: _codeText];
    
    _codeText.sd_layout
    .leftSpaceToView(text1, 10*ScrenScale)
    .rightSpaceToView(text1, 10*ScrenScale)
    .topSpaceToView(text1, 10*ScrenScale)
    .bottomSpaceToView(text1, 10*ScrenScale);
    
    _getCodeButton = [[UIButton alloc]init];
    [_getCodeButton setTitleColor: NAVIGATIONRED forState:UIControlStateNormal];
    [_getCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
    [_getCodeButton setBackgroundColor:[UIColor whiteColor]];
    _getCodeButton.layer.borderWidth = 1;
    _getCodeButton.layer.borderColor = NAVIGATIONRED.CGColor;
    [self addSubview:_getCodeButton];
    _getCodeButton.sd_layout
    .leftSpaceToView(text1, 0)
    .topEqualToView(text1)
    .bottomEqualToView(text1)
    .rightSpaceToView(self, 30*ScrenScale);
    
    _nextButton = [[UIButton alloc]init];
    [_nextButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
    _nextButton.layer.borderWidth =1;
    _nextButton .layer.borderColor =NAVIGATIONRED.CGColor;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [self addSubview:_nextButton];
    _nextButton.sd_layout
    .leftEqualToView(text1)
    .topSpaceToView(text1, 20*ScrenScale)
    .heightRatioToView(text1, 1.0)
    .rightEqualToView(_getCodeButton);
    
}



@end
