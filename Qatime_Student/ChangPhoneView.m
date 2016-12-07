
//
//  ChangPhoneView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangPhoneView.h"

@implementation ChangPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)setupViews{
    
    _phoneNumber = [[UITextField alloc]init];
    _phoneNumber.placeholder = @"输入新手机号(仅支持大陆地区11位)";
    _phoneNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _phoneNumber.layer.borderWidth = 1;
    
    _keyCode = [[UITextField alloc]init];
    _keyCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _keyCode.layer.borderWidth = 1;
    
    _getKeyButton = [[UIButton alloc]init];
    [_getKeyButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_getKeyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getKeyButton setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.00  ]];
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton setTitleColor:[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.00] forState:UIControlStateNormal];
    
    _finishButton.layer.borderWidth =1;
    _finishButton .layer.borderColor =[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.00].CGColor;
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    
    
    [self layoutViews];

    
}

- (void)layoutViews{
    
    
    [self sd_addSubviews:@[_phoneNumber,_keyCode,_getKeyButton,_finishButton]];
    
    
    
    _phoneNumber.sd_layout
    .leftSpaceToView(self,20)
    .topSpaceToView(self,30)
    .rightSpaceToView(self,20)
    .heightRatioToView(self,0.065);
    
    
    
    
    _keyCode.sd_layout
    .leftSpaceToView(self,20)
    .heightRatioToView(self,0.065f)
    .widthIs(self.width_sd/2)
    .topSpaceToView(_phoneNumber,20);
    
    _getKeyButton.sd_layout
    .leftSpaceToView(_keyCode,0)
    .rightSpaceToView(self,20)
    .heightRatioToView(_keyCode,1.0f)
    .topEqualToView(_keyCode);
    
    _finishButton.sd_layout
    .leftSpaceToView(self,20)
    .rightSpaceToView(self,20)
    .topSpaceToView(_getKeyButton,20)
    .heightRatioToView(_getKeyButton,1.0f);
    _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
    
    

    
    
    
}


@end
