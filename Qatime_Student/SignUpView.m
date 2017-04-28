//
//  SignUpView.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpView.h"

@interface SignUpView()<UITextFieldDelegate>{
    
    /**选择协议*/
    BOOL selectedPolicy;
    
}

@end

@implementation SignUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        /* 手机号输入框的创建和布局*/
        UIView *text1 = [[UIView alloc]init];
        text1.backgroundColor = [UIColor whiteColor];
        [self addSubview:text1];
        text1.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text1.layer.borderWidth = 0.5;
        text1.sd_layout
        .topSpaceToView(self,10*ScrenScale320)
        .leftSpaceToView(self,30)
        .rightSpaceToView(self,30)
        .heightIs(40);
        
        _phoneNumber = [[UITextField alloc]init];
        _phoneNumber.font = TEXT_FONTSIZE;
        [text1 addSubview:_phoneNumber];
        _phoneNumber.placeholder =NSLocalizedString(@"请输入大陆地区11位手机号", nil);
        _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumber.sd_layout
        .leftSpaceToView(text1, 10)
        .rightSpaceToView(text1, 10)
        .topSpaceToView(text1, 10)
        .bottomSpaceToView(text1, 10);
        
        
        /* 手机校验码输入框*/
        UIView *text2 = [[UIView alloc]init];
        text2.backgroundColor = [UIColor whiteColor];
        [self addSubview:text2];
        text2.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text2.layer.borderWidth = 0.5;
        text2.sd_layout
        .topSpaceToView(text1,10*ScrenScale320)
        .leftEqualToView(text1)
        .widthRatioToView(text1, 0.6)
        .heightRatioToView(text1, 1.0);
        
        _checkCode = [[UITextField alloc]init];
        _checkCode.font = TEXT_FONTSIZE;
        _checkCode.keyboardType = UIKeyboardTypeNumberPad;
        [text2 addSubview:_checkCode];
        _checkCode.placeholder = NSLocalizedString(@"输入校验码", nil) ;
        _checkCode.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _checkCode.sd_layout
        .leftSpaceToView(text2, 10)
        .rightSpaceToView(text2, 10)
        .topSpaceToView(text2, 10)
        .bottomSpaceToView(text2, 10);
        
        /* 获取校验码按钮*/
        _getCheckCodeButton = [[UIButton alloc]init];
        [self addSubview:_getCheckCodeButton];
        _getCheckCodeButton.backgroundColor = [UIColor lightGrayColor];
        _getCheckCodeButton.layer.borderWidth = 1;
        _getCheckCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getCheckCodeButton.titleLabel.font = TEXT_FONTSIZE;
        _getCheckCodeButton.sd_layout
        .topEqualToView(text2)
        .bottomEqualToView(text2)
        .leftSpaceToView(text2, 0)
        .rightEqualToView(text1);
        [_getCheckCodeButton setTitle:NSLocalizedString(@"获取校验码", nil) forState:UIControlStateNormal];
        [_getCheckCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getCheckCodeButton.enabled = NO;
        [_getCheckCodeButton setEnlargeEdge:10];
        
        /* 用户密码输入框*/
        UIView *text3 = [[UIView alloc]init];
        text3.backgroundColor = [UIColor whiteColor];
        [self addSubview:text3];
        text3.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text3.layer.borderWidth = 0.5;
        text3.sd_layout
        .topSpaceToView(text2,10*ScrenScale320)
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightRatioToView(text1, 1.0);
        
        _userPassword = [[UITextField alloc]init];
        _userPassword.font = TEXT_FONTSIZE;
        [text3 addSubview:_userPassword];
        _userPassword.placeholder = NSLocalizedString(@"输入登录密码", nil);
        _userPassword.sd_layout
        .topSpaceToView(text3, 10)
        .bottomSpaceToView(text3, 10)
        .leftSpaceToView(text3, 10)
        .rightSpaceToView(text3, 10);
        _userPassword.secureTextEntry = YES;
        
        /* 确认登录密码框*/
        UIView *text4  = [[UIView alloc]init];
        text4.backgroundColor = [UIColor whiteColor];
        [self addSubview:text4];
        text4.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        text4.layer.borderWidth = 0.5;
        
        text4.sd_layout
        .topSpaceToView(text3,10*ScrenScale320)
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .heightRatioToView(text1, 1.0);
        
        _userPasswordCompare =[[UITextField alloc]init];
        _userPasswordCompare.font = TEXT_FONTSIZE;
        [text4 addSubview:_userPasswordCompare];
        _userPasswordCompare.placeholder =NSLocalizedString(@"确认登录密码", nil);
        _userPasswordCompare.sd_layout
        .leftSpaceToView(text4, 10)
        .rightSpaceToView(text4, 10)
        .topSpaceToView(text4, 10)
        .bottomSpaceToView(text4, 10);
        _userPasswordCompare.secureTextEntry = YES;
        
        
        /* 同意用户协议的选择框*/
        _chosenButton = [[UIButton alloc]init];
        
        [self addSubview:_chosenButton];
        _chosenButton .layer.borderColor =TITLECOLOR.CGColor;
        _chosenButton.layer.borderWidth=1.0f;
        _chosenButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        _chosenButton.selected = NO;
        [_chosenButton setEnlargeEdge:20];
        
        
        /* 同意label*/
        _accessLabel= [[UILabel alloc]init];
        [self addSubview:_accessLabel];
        [_accessLabel setText:NSLocalizedString(@"同意", nil)];
        _accessLabel.textColor = TITLECOLOR;
        _accessLabel.sd_layout
        .leftSpaceToView(_chosenButton,10*ScrenScale320)
        .topEqualToView(_chosenButton)
        .bottomEqualToView(_chosenButton);
        [_accessLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"同意《答疑时间用户协议》"];
        [string addAttributes:@{NSFontAttributeName:TEXT_FONTSIZE,NSForegroundColorAttributeName:TITLECOLOR} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName:TEXT_FONTSIZE,NSForegroundColorAttributeName:[UIColor colorWithRed:0.11 green:0.64 blue:0.92 alpha:1.00]} range:NSMakeRange(2, string.length-2)];
        
        _accessLabel.attributedText = string;
        _accessLabel.isAttributedContent = YES;
        _accessLabel.sd_layout
        .leftEqualToView(text1)
        .topSpaceToView(text4, 10*ScrenScale320)
        .autoHeightRatio(0);
        [_accessLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        [_accessLabel updateLayout];
        
        _chosenButton.sd_layout
        .leftEqualToView(text1)
        .topSpaceToView(text4, 10*ScrenScale320)
        .heightRatioToView(_accessLabel, 1.0)
        .widthEqualToHeight();
        
        _accessLabel.sd_layout
        .leftSpaceToView(_chosenButton, 10);
        [_accessLabel updateLayout];
        
        
        /* 下一步按钮*/
        _nextStepButton = [[UIButton alloc]init];
        _nextStepButton.titleLabel.font = TEXT_FONTSIZE;
        _nextStepButton.layer.borderWidth = 1;
        _nextStepButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _nextStepButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI] ;
        [self addSubview:_nextStepButton];
        [_nextStepButton setTitle:NSLocalizedString(@"下一步",nil) forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = [UIColor lightGrayColor];
        _nextStepButton.sd_layout
        .leftEqualToView(text1)
        .rightEqualToView(text1)
        .topSpaceToView(_accessLabel, 10*ScrenScale320)
        .heightRatioToView(text1, 1.0);
        
    }
    return self;
}


@end
