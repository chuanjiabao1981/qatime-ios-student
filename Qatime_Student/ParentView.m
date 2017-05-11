//
//  ParentView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ParentView.h"

@interface ParentView (){
    
    
    
}

@end

@implementation ParentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *para = [[UILabel alloc]init];
        para.text = @"当前家长手机";
        para.textColor = [UIColor lightGrayColor];
        
        /* 家长手机*/
        _parentPhoneLabel = [[UILabel alloc]init];
        _parentPhoneLabel.textColor = [UIColor grayColor];
//        _parentPhoneLabel.layer.borderWidth =1;
//        _parentPhoneLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        /* 登录密码*/
//        _password = [[UITextField alloc]init];
//        _password.placeholder = @" 输入登录密码";
//        _password.layer.borderWidth =1;
//        _password.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        
        /* 新的家长手机号*/
        _parentPhoneText = [[UITextField alloc]init];
        _parentPhoneText.placeholder = @" 输入新家长手机";
        _parentPhoneText.layer.borderWidth =1;
        _parentPhoneText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _parentPhoneText.keyboardType = UIKeyboardTypeNumberPad;
        
        
        /* 校验码*/
        
        _keyCodeText =  [[UITextField alloc]init];
        _keyCodeText.placeholder = @" 输入校验码";
        _keyCodeText.layer.borderWidth =1;
        _keyCodeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _keyCodeText.keyboardType = UIKeyboardTypeNumberPad;
        

        /* 获取验证码*/
        _getCodeButton = [[UIButton alloc]init];
        _getCodeButton.backgroundColor = [UIColor lightGrayColor];
        [_getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
        _getCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getCodeButton.layer.borderWidth =1;
        
        /* 完成按钮*/
        
        _finishButton =[[UIButton alloc]init];
//        _finishButton.backgroundColor = [UIColor lightGrayColor];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _finishButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _finishButton.layer.borderWidth = 1;
                
        [self sd_addSubviews:@[para,_parentPhoneLabel,_parentPhoneText,_keyCodeText,_getCodeButton,_finishButton]];
        
        /* 布局*/
        para.sd_layout
        .leftSpaceToView (self,20)
        .topSpaceToView(self,30)
        .autoHeightRatio(0);
        [para setSingleLineAutoResizeWithMaxWidth:500];
        
        _parentPhoneLabel.sd_layout
        .centerXEqualToView(self)
        .topEqualToView(para)
        .bottomEqualToView(para);
        [_parentPhoneLabel setSingleLineAutoResizeWithMaxWidth:1000];
        
//        _password .sd_layout
//        .topSpaceToView(para,30)
//        .leftSpaceToView(self,20)
//        .rightSpaceToView(self,20)
//        .heightRatioToView(self,0.065f);
        
        _parentPhoneText.sd_layout
        .topSpaceToView(para,30)
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .heightRatioToView(self,0.065f);
       
        _keyCodeText.sd_layout
        .leftEqualToView(_parentPhoneText)
        .widthIs(self.width_sd/2+20)
        .topSpaceToView(_parentPhoneText,20)
        .heightRatioToView(_parentPhoneText,1);
        
        _getCodeButton.sd_layout
        .leftSpaceToView(_keyCodeText,0)
        .rightEqualToView(_parentPhoneText)
        .topEqualToView(_keyCodeText)
        .bottomEqualToView(_keyCodeText);
        _getCodeButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        _finishButton.sd_layout
        .leftEqualToView(_keyCodeText)
        .rightEqualToView(_getCodeButton)
        .topSpaceToView(_keyCodeText,30)
        .heightRatioToView(_keyCodeText,1.0f);
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
    }
    return self;
}

@end
