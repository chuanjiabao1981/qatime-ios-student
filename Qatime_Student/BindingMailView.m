//
//  BindingMailView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingMailView.h"

@implementation BindingMailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *phone = [UILabel new];
        phone.text = @"当前绑定手机";
        phone.textColor = TITLECOLOR;
        
        _phoneLabel = [UILabel new];
        _phoneLabel.textColor = TITLECOLOR;
        
        UIView *square = [[UIView alloc]init];
        square.layer.borderColor = [UIColor lightGrayColor].CGColor;
        square.layer.borderWidth = 0.8;
        
        _keyCodeText = [[UITextField alloc]init];
        _keyCodeText.placeholder = @"输入校验码";
        
        _getKeyCodeButton = [UIButton new];
        _getKeyCodeButton.backgroundColor =[UIColor lightGrayColor];
        [_getKeyCodeButton setTitle:@"获取校验码" forState:UIControlStateNormal];
        [_getKeyCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _nextStepButton = [UIButton new];
        _nextStepButton.backgroundColor = BUTTONRED;
        _nextStepButton.layer.borderWidth = 1;
        _nextStepButton.layer.borderColor = BUTTONRED.CGColor;
        
        [_nextStepButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        
        /*布局*/
        
        [self sd_addSubviews:@[phone,_phoneLabel,square,_getKeyCodeButton,_nextStepButton]];
        [square addSubview:_keyCodeText];
        
        
        phone.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [phone setSingleLineAutoResizeWithMaxWidth:400];
        
        _phoneLabel.sd_layout
        .leftSpaceToView(phone,20)
        .topEqualToView(phone)
        .bottomEqualToView(phone);
        [_phoneLabel setSingleLineAutoResizeWithMaxWidth:1000];
        
        square.sd_layout
        .leftEqualToView(phone)
        .topSpaceToView(phone,20)
        .widthIs(self.width_sd*2/3-40)
        .heightIs(self.height_sd*0.065);
        
        _keyCodeText.sd_layout
        .leftSpaceToView(square,10)
        .rightSpaceToView(square,10)
        .topSpaceToView(square,10)
        .bottomSpaceToView(square,10);
        
        _getKeyCodeButton.sd_layout
        .leftSpaceToView(square,0)
        .rightSpaceToView(self,20)
        .topEqualToView(square)
        .bottomEqualToView(square);
        
        _nextStepButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_getKeyCodeButton,30)
        .heightRatioToView(_getKeyCodeButton,1.0);
        
        
        
        
        
        
    }
    return self;
}

@end
