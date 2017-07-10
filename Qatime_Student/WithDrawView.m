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
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        //小背景
        UIView *content = [[UIView alloc]init];
        [self addSubview:content];
        content.backgroundColor = [UIColor whiteColor];
        content.sd_layout
        .topSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(100);
        
        /* 外框*/
        UIView *text = [[UIView alloc]init];
        text.layer.borderColor = [UIColor lightGrayColor].CGColor;
        text.layer.borderWidth = 0.8;
        
        [content addSubview:text];
        text.sd_layout
        .leftSpaceToView(content,20*ScrenScale)
        .rightSpaceToView(content,20*ScrenScale)
        .topSpaceToView(content,20*ScrenScale)
        .heightIs(40*ScrenScale320);
        text.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        /* 元*/
        UILabel *yuan = [[UILabel alloc]init];
        yuan.text =@"元";
        yuan.textColor = TITLECOLOR;
        [text addSubview:yuan];
        yuan.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .rightSpaceToView(text,10)
        .widthEqualToHeight();
        
        
        /* 内框*/
        _moneyText = [[UITextField alloc]init];
        _moneyText.placeholder = @"请输入想要提现的金额";
        _moneyText.font = TEXT_FONTSIZE;
        [text addSubview:_moneyText];
        _moneyText.sd_layout
        .topSpaceToView(text,10)
        .bottomSpaceToView(text,10)
        .leftSpaceToView(text,10)
        .rightSpaceToView(text,10);
        
        
        /* 微信支付*/
        UILabel *wechatpay = [[UILabel alloc]init];
        wechatpay.text = @"微信提现";
        wechatpay.font = TEXT_FONTSIZE;
        wechatpay.textColor = TITLECOLOR;
        [content addSubview:wechatpay];
        wechatpay.sd_layout
        .topSpaceToView(text, 20*ScrenScale)
        .autoHeightRatio(0);
        [wechatpay setSingleLineAutoResizeWithMaxWidth:200];
        
        UIImageView *wechatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat"]];
        [content addSubview:wechatImage];
        wechatImage.sd_layout
        .centerYEqualToView(wechatpay)
        .heightRatioToView(wechatpay, 1.0)
        .widthEqualToHeight()
        .leftEqualToView(text);
        
        wechatpay.sd_layout
        .leftSpaceToView(wechatImage, 10*ScrenScale);
        
        UIImageView *select = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"selectedCircle"]];
        [content addSubview:select];
        select.sd_layout
        .rightEqualToView(text)
        .topEqualToView(wechatImage)
        .bottomEqualToView(wechatImage)
        .widthEqualToHeight();
        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = SEPERATELINECOLOR_2;
        [content addSubview:line];
        line.sd_layout
        .leftSpaceToView(content, 0)
        .rightSpaceToView(content, 0)
        .topSpaceToView(wechatpay, 20*ScrenScale)
        .heightIs(0.5);
        
        UILabel *tips = [[UILabel alloc]init];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:@"提现说明:\n1.目前仅支持提现到微信钱包；\n2.申请提现需要进行微信授权；\n3.请仔细核对提现信息，仅限账号本人操作。"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        [contentStr addAttributes:@{NSForegroundColorAttributeName:BUTTONRED,NSFontAttributeName:TEXT_FONTSIZE_MIN} range:NSMakeRange(0, 5)];
        [contentStr addAttributes:@{NSForegroundColorAttributeName:TITLECOLOR,NSFontAttributeName:TEXT_FONTSIZE_MIN} range:NSMakeRange(6, contentStr.length-6)];
        [contentStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, contentStr.length)];
        tips.isAttributedContent = YES;
        tips.attributedText = contentStr;
        [content addSubview:tips];
        tips.sd_layout
        .leftEqualToView(text)
        .rightEqualToView(text)
        .topSpaceToView(line, 10)
        .autoHeightRatio(0);
        
        [content setupAutoHeightWithBottomView:tips bottomMargin:10*ScrenScale];
        
        
        /* 下一步按钮*/
        _nextStepButton = [[UIButton alloc]init];
        [_nextStepButton setTitle:@"授权并申请" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _nextStepButton.layer.borderColor =BUTTONRED.CGColor;
        _nextStepButton.layer.borderWidth = 1.0;
        
        [self addSubview:_nextStepButton];
        _nextStepButton.sd_layout
        .leftSpaceToView(self, 20*ScrenScale)
        .rightSpaceToView(self, 20*ScrenScale)
        .topSpaceToView(content, 20*ScrenScale)
        .heightRatioToView(text, 1.0);
        
        
    }
    return self;
}

@end
