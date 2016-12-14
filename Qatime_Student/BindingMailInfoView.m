//
//  BindingMailInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/14.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingMailInfoView.h"

@implementation BindingMailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        UILabel *mailSquare = [UILabel new];
        mailSquare.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mailSquare.layer.borderWidth = 0.8;
        
        
        _mailText = [[UITextField alloc]init];
        _mailText.placeholder = @"输入新的邮箱账号";
        
        
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
        
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        
        /*布局*/
        
        [mailSquare addSubview:_mailText];
        
        [square addSubview:_keyCodeText];
        
        [self sd_addSubviews:@[mailSquare,square,_getKeyCodeButton,_nextStepButton]];
        
        
        
        mailSquare.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .heightIs(self.height_sd*0.065);
        
        
        _mailText.sd_layout
        .leftSpaceToView(mailSquare,10)
        .topSpaceToView(mailSquare,10)
        .rightSpaceToView(mailSquare,10)
        .bottomSpaceToView(mailSquare,10);
        
        
        
        square.sd_layout
        .leftEqualToView(mailSquare)
        .topSpaceToView(mailSquare,20)
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
