//
//  ChargeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChargeView.h"

@interface ChargeView (){
    
    
    UIView *text;
    
    
}

@end

@implementation ChargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 外框*/
        text = [[UIView alloc]init];
        text.layer.borderColor = [UIColor lightGrayColor].CGColor;
        text.layer.borderWidth = 0.6f;
        
        /* 输入框*/
        _moneyText = [[UITextField alloc]init];
        _moneyText.placeholder = @"请输入充值金额";
        
        /* 元*/
        UILabel *yuan = [[UILabel alloc]init];
        yuan .text = @"元";
        yuan.textColor = [UIColor blackColor];
        
        /* 微信支付按钮*/
        
        _wechatButton = [[UIButton alloc]init];
        _wechatButton.selected = NO;
        _wechatButton.layer.borderWidth = 0.6;
        _wechatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIImageView *wechaImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat"]];
        
        UILabel *wechatPay = [[UILabel alloc]init];
        wechatPay.text = @"微信支付";
        wechatPay.textColor = [UIColor lightGrayColor];
        
        
        
        /* 微信支付按钮*/
        
        _alipayButton = [[UIButton alloc]init];
        _alipayButton.selected = NO;
        _alipayButton.layer.borderWidth = 0.6;
        _alipayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIImageView *alipayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alipay"]];
        
        UILabel *aliPay = [[UILabel alloc]init];
        aliPay.text = @"支付宝支付";
        aliPay.textColor = [UIColor lightGrayColor];
        
        UILabel *tip = [[UILabel alloc]init];
        tip.text = @"选择支付方式:";
        tip.textColor = [UIColor lightGrayColor];
        
        
        
        _finishButton = [[UIButton alloc]init];
        _finishButton .layer.borderColor = BUTTONRED.CGColor;
        _finishButton.layer.borderWidth =1;
        
        [_finishButton setTitle:@"立即充值" forState:UIControlStateNormal];
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];

        
        
        
        /* 布局*/
        [self sd_addSubviews:@[text,_wechatButton,wechaImage,wechatPay,_alipayButton,alipayImage,aliPay,tip,_finishButton]];
        
        [text sd_addSubviews:@[yuan,_moneyText]];
        
        
        /* 框*/
        text.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .heightRatioToView(self,0.065);
        
        yuan.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .rightSpaceToView(text,10);
        [yuan setSingleLineAutoResizeWithMaxWidth:100];
        
        _moneyText.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .rightSpaceToView(yuan,0)
        .leftSpaceToView(text,10);
        
        
        
        wechatPay.sd_layout
        .leftSpaceToView(self,self.width_sd/2)
        .topSpaceToView(text,30)
        .autoHeightRatio(0);
        [wechatPay setSingleLineAutoResizeWithMaxWidth:1000];
        
        wechaImage.sd_layout
        .rightSpaceToView(wechatPay,0)
        .centerYEqualToView(wechatPay)
        .heightRatioToView(wechatPay,1.2)
        .widthEqualToHeight();
        
        _wechatButton.sd_layout
        .centerYEqualToView(wechaImage)
        .rightSpaceToView(wechaImage,5)
        .heightRatioToView(wechatPay,1)
        .widthEqualToHeight();
        
        _wechatButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        
        
        tip.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(text,30)
        .autoHeightRatio(0)
        .rightSpaceToView(_wechatButton,10);
        tip.textAlignment = NSTextAlignmentLeft;
        
        
        alipayImage.sd_layout
        .topSpaceToView(wechaImage,20)
        .leftEqualToView(wechaImage)
        .rightEqualToView(wechaImage)
        .heightRatioToView(wechaImage,1.0f);
        
        aliPay.sd_layout
        .leftEqualToView(wechatPay)
        .centerYEqualToView(alipayImage)
        .autoHeightRatio(0);
        [aliPay setSingleLineAutoResizeWithMaxWidth:500];
        
        _alipayButton.sd_layout
        .leftEqualToView(_wechatButton)
        .rightEqualToView(_wechatButton)
        .centerYEqualToView(alipayImage)
        .heightRatioToView(_wechatButton,1.0f);
        
        _alipayButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        
        
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(alipayImage,30)
        .heightRatioToView(text,1.0);
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        
        
    }
    return self;
}

@end
