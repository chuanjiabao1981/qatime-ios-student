//
//  VerifyPasswordView.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VerifyPasswordView.h"

#define SQUAREWIDTH self.width_sd*0.14

@implementation VerifyPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        UIView *text = [[UIView alloc]init];
        [self addSubview:text];
        text.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text.layer.borderWidth = 1;
        text.backgroundColor = [UIColor whiteColor];
        
        text.sd_layout
        .leftSpaceToView(self, 30*ScrenScale)
        .rightSpaceToView(self, 30*ScrenScale)
        .topSpaceToView(self, 30*ScrenScale)
        .heightIs(40*ScrenScale320);
        
        
        _passwordText = [[UITextField alloc]init];
        [text addSubview:_passwordText];
        _passwordText.placeholder = @"输入登录密码";
        _passwordText.secureTextEntry = YES;
        _passwordText.sd_layout
        .leftSpaceToView(text, 10*ScrenScale)
        .rightSpaceToView(text, 10*ScrenScale)
        .topSpaceToView(text, 10*ScrenScale)
        .bottomSpaceToView(text, 10*ScrenScale);
        
        
        _nextButton = [[UIButton alloc]init];
        _nextButton.layer.borderWidth = 1;
        _nextButton.layer.borderColor = TITLECOLOR.CGColor;
        [_nextButton setBackgroundColor:TITLECOLOR];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:_nextButton];
        _nextButton.sd_layout
        .leftEqualToView(text)
        .rightEqualToView(text)
        .topSpaceToView(text, 20*ScrenScale)
        .heightRatioToView(text, 1.0);
        
    }
    return self;
}

@end
