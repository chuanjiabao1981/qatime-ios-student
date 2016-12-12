//
//  WithDrawView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithDrawView.h"

@interface WithDrawView (){
    
    
    
 
    
    
}

@end

@implementation WithDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 外框*/
        UIView *text = [[UIView alloc]init];
        text.layer.borderColor = [UIColor lightGrayColor].CGColor;
        text.layer.borderWidth = 0.8;
        
        /* 内框*/
        _moneyText = [[UITextField alloc]init];
        _moneyText.placeholder = @"请输入想要提现的金额";
        
        
        /* 元*/
        UILabel *yuan = [[UILabel alloc]init];
        yuan.text =@"元";
        yuan.textColor = TITLECOLOR;
        
        
        UILabel *method = [[UILabel alloc]init];
        method.text=@"提现方式:";
        method.textColor= TITLECOLOR;
        
        
        /* 支付宝支付*/
        UILabel *alipay = [[UILabel alloc]init];
        alipay.text = @"支付宝支付";
        alipay.textColor = TITLECOLOR;
        
        UIImageView *aliImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alipay"]];
        
        _alipayButton = [[UIButton alloc]init];
        _alipayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _alipayButton.layer.borderWidth = 0.6;
        
        
        /* 转账*/
        UILabel *transfer = [[UILabel alloc]init];
        transfer.text = @"转账";
        transfer.textColor = TITLECOLOR;
        
        UIImageView *transferImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card"]];
        
        _transferButton = [[UIButton alloc]init];
        _transferButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _transferButton.layer.borderWidth = 0.6;

        /* 下一步按钮*/
        _nextStepButton = [[UIButton alloc]init];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        _nextStepButton.layer.borderColor =BUTTONRED.CGColor;
        _nextStepButton.layer.borderWidth = 1.0;
        
        
        
        /* 布局*/
        [self sd_addSubviews:@[text,method,_alipayButton,aliImage,alipay,_transferButton,transferImage,transfer,_nextStepButton]];
        
        [text sd_addSubviews:@[yuan,_moneyText]];
        
        /* 文字输入框*/
        text.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .heightRatioToView(self,0.07);
        
        text.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        yuan.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .rightSpaceToView(text,10)
        .widthEqualToHeight();
        
        _moneyText.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .leftSpaceToView(text,10)
        .rightSpaceToView(text,10);
        
        /* 支付宝部分布局*/
        alipay.sd_layout
        .topSpaceToView(text,self.height_sd*0.07)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [alipay setSingleLineAutoResizeWithMaxWidth:1000.00];
        
        aliImage.sd_layout
        .rightSpaceToView(alipay,5)
        .topEqualToView(alipay)
        .bottomEqualToView(alipay)
        .widthEqualToHeight();
        
        _alipayButton.sd_layout
        .rightSpaceToView(aliImage,10)
        .centerYEqualToView(aliImage)
        .heightRatioToView(aliImage,0.8)
        .widthEqualToHeight();
        _alipayButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        
        /* 转账部分*/
        
        transferImage.sd_layout
        .topSpaceToView(aliImage,20)
        .leftEqualToView(aliImage)
        .widthRatioToView(aliImage,1.0)
        .heightRatioToView(aliImage,1.0);
        
        transfer.sd_layout
        .leftEqualToView(alipay)
        .topEqualToView(transferImage)
        .bottomEqualToView(transferImage);
        [transfer setSingleLineAutoResizeWithMaxWidth:1000.00];
        
        _transferButton.sd_layout
        .centerYEqualToView(transferImage)
        .heightRatioToView(_alipayButton,1.0)
        .widthRatioToView(_alipayButton,1.0)
        .rightEqualToView(_alipayButton);
        _transferButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        
        /* 下一步*/
        _nextStepButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(transfer,30)
        .heightRatioToView(self,0.065);
        
        _nextStepButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        /* 提现方式*/
        method.sd_layout
        .leftSpaceToView(self,20)
        .topEqualToView(alipay)
        .autoHeightRatio(0);
        [method setSingleLineAutoResizeWithMaxWidth:1000.0];
        
        
        
        
    }
    return self;
}

@end
