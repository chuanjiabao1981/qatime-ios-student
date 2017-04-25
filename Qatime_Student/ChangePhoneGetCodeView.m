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
        
        
        [self setupViews];
        
        
    }
    return self;
}

- (void)setupViews{
    
    _label = [[UILabel alloc]init];
    _label.text = @"当前绑定手机:";
    _label.textColor = [UIColor blackColor];
    
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.textColor = [UIColor blackColor];
    
    _codeText = [[UITextField alloc]init];
    _codeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _codeText.layer.borderWidth = 1;
    _codeText.placeholder = @"输入收到的验证码";
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    
    _getCodeButton = [[UIButton alloc]init];
    [_getCodeButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.00  ]];
    
    
    _nextButton = [[UIButton alloc]init];
    [_nextButton setTitleColor:[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.00] forState:UIControlStateNormal];
    
    _nextButton.layer.borderWidth =1;
    _nextButton .layer.borderColor =[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.00].CGColor;
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    
    [self layoutViews];
    
}


- (void)layoutViews{
    
    [self sd_addSubviews:@[_label,_phoneLabel,_codeText,_getCodeButton,_nextButton]];
    
    _label.sd_layout
    .leftSpaceToView(self,20)
    .topSpaceToView(self,30)
    .autoHeightRatio(0);
    
    [_label setSingleLineAutoResizeWithMaxWidth:1000];
    
    
    _phoneLabel.sd_layout
    .centerXEqualToView(self)
    .topEqualToView(_label)
    .autoHeightRatio(0);
    [_phoneLabel setSingleLineAutoResizeWithMaxWidth:1000];
    
    
    _codeText.sd_layout
    .leftSpaceToView(self,20)
    .heightRatioToView(self,0.065f)
    .widthIs(self.width_sd/2)
    .topSpaceToView(_label,20);
    
    _getCodeButton.sd_layout
    .leftSpaceToView(_codeText,0)
    .rightSpaceToView(self,20)
    .heightRatioToView(_codeText,1.0f)
    .topEqualToView(_codeText);
    
    _nextButton.sd_layout
    .leftSpaceToView(self,20)
    .rightSpaceToView(self,20)
    .topSpaceToView(_getCodeButton,20)
    .heightRatioToView(_getCodeButton,1.0f);
    _nextButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
    
}

@end
