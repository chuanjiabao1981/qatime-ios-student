//
//  WithDrawInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithDrawInfoView.h"

@implementation WithDrawInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /* 账号框*/
        UIView *account = [[UIView alloc]init];
        account.layer.borderColor = [UIColor lightGrayColor].CGColor;
        account.layer.borderWidth = 0.8;
        
        _accountText = [[UITextField alloc]init];
        
        
        
        /* 姓名*/
        UIView *name = [[UIView alloc]init];
        name.layer.borderColor = [UIColor lightGrayColor].CGColor;
        name.layer.borderWidth = 0.8;
        
        _nameText = [[UITextField alloc]init];
        _nameText.placeholder = @"请输入真实姓名";
        
        /* 验证码*/
//        UIView *keycode = [[UIView alloc]init];
//        keycode.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        keycode.layer.borderWidth = 0.8;
        
//        _keyCodeText = [[UITextField alloc]init];
//        _keyCodeText.placeholder = @"输入收到的验证码";
//        
//        /* 请求验证码按钮*/
//        _getKeyCodeButton = [[UIButton alloc]init];
//        _getKeyCodeButton.layer.borderWidth = 0.8;
//        _getKeyCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _getKeyCodeButton.backgroundColor = [UIColor grayColor];
//        [_getKeyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        
        /* 提交申请按钮*/
        _applyButton = [[UIButton alloc]init];
        [_applyButton setTitle:@"申请提现" forState:UIControlStateNormal];
        _applyButton.layer.borderColor = BUTTONRED.CGColor;
        _applyButton.layer.borderWidth = 1.0;
        [_applyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        
        
        /* 布局*/
        
        [self sd_addSubviews:@[account,name,_applyButton]];
        
        [account addSubview:_accountText];
        [name addSubview:_nameText];
//        [keycode addSubview:_keyCodeText];
        
        
        account.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .heightRatioToView(self,0.065);
        
        _accountText.sd_layout
        .leftSpaceToView(account,10)
        .topSpaceToView(account,10)
        .rightSpaceToView(account,10)
        .bottomSpaceToView(account,10);
        
        
        name.sd_layout
        .leftEqualToView(account)
        .rightEqualToView(account)
        .topSpaceToView(account,20)
        .heightRatioToView(account,1.0);
        
        _nameText.sd_layout
        .leftSpaceToView(name,10)
        .rightSpaceToView(name,10)
        .topSpaceToView(name,10)
        .bottomSpaceToView(name,10);
        
//        keycode.sd_layout
//        .leftEqualToView(name)
//        .topSpaceToView(name,20)
//        .heightRatioToView(name,1.0)
//        .widthIs(self.width_sd*2/3-40);
//        
//        
//        _keyCodeText.sd_layout
//        .leftSpaceToView(keycode,10)
//        .topSpaceToView(keycode,10)
//        .bottomSpaceToView(keycode,10)
//        .rightSpaceToView(keycode,10);
//        
//        _getKeyCodeButton.sd_layout
//        .leftSpaceToView(keycode,0)
//        .topEqualToView(keycode)
//        .bottomEqualToView(keycode)
//        .rightSpaceToView(self,20);
        
        _applyButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(name,20)
        .heightRatioToView(self,0.065);
        
        
        
        
    }
    return self;
}

@end
