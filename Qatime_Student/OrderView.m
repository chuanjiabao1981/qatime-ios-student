//
//  OrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//


#import "OrderView.h"

#define LINESPACE self.height_sd/80.0


@implementation OrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //课程信息部分白色背景图
        _infoView = [[UIView alloc]init];
        [self addSubview:_infoView];
        _infoView.backgroundColor = [UIColor whiteColor];
        
        _infoView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(200);
        
        //课程名
        _className = [UILabel new];
        _className.textColor = TITLECOLOR;
        _className.textAlignment = NSTextAlignmentLeft;
        [_infoView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_infoView,20)
        .rightSpaceToView(_infoView,20)
        .topSpaceToView(_infoView,10)
        .autoHeightRatio(0);
        
        //分割线1
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = SEPERATELINECOLOR;
        [_infoView addSubview:line1];
        line1.sd_layout
        .leftSpaceToView(_infoView,15)
        .rightSpaceToView(_infoView,15)
        .topSpaceToView(_className,10)
        .heightIs(0.5);
        
        
        
        /* 科目*/
        UILabel *subject = [UILabel new];
        subject.text = @"科        目";
        subject.textColor = [UIColor blackColor];
        [_infoView addSubview:subject];
        
        subject.sd_layout
        .topSpaceToView(line1,10)
        .leftSpaceToView(_infoView,20)
        .autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _subjectLabel = [UILabel new];
        _subjectLabel.textColor = TITLECOLOR;
        [_infoView addSubview:_subjectLabel];
        
        _subjectLabel.sd_layout
        .topEqualToView(subject)
        .bottomEqualToView(subject)
        .leftSpaceToView(subject,20);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        /* 年级*/
        UILabel *grade = [UILabel new];
        grade.text = @"年        级";
        grade.textColor = [UIColor blackColor];
        [_infoView addSubview:grade];
        
        grade.sd_layout
        .leftEqualToView(subject)
        .topSpaceToView(subject,20)
        .autoHeightRatio(0);
        [grade setSingleLineAutoResizeWithMaxWidth:200];
        
        _gradeLabel = [UILabel new];
        _gradeLabel.textColor = TITLECOLOR;
        [_infoView addSubview:_gradeLabel];
        
        _gradeLabel.sd_layout
        .leftEqualToView(_subjectLabel)
        .topEqualToView(grade)
        .bottomEqualToView(grade);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        /* 老师*/
        UILabel *teacher = [UILabel new];
        teacher.text = @"授课老师";
        teacher.textColor = [UIColor blackColor];
        [_infoView addSubview:teacher];
        teacher.sd_layout
        .leftEqualToView(grade)
        .topSpaceToView(grade,20)
        .autoHeightRatio(0);
        [teacher setSingleLineAutoResizeWithMaxWidth:200];
        
        _teacheNameLabel = [UILabel new];
        _teacheNameLabel.textColor = TITLECOLOR;
        [_infoView addSubview:_teacheNameLabel];
        
        _teacheNameLabel.sd_layout
        .leftEqualToView(_gradeLabel)
        .topEqualToView(teacher)
        .bottomEqualToView(teacher);
        [_teacheNameLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 课时总数*/
        UILabel *classtime = [UILabel new];
        classtime.text = @"课时总数";
        classtime.textColor = [UIColor blackColor];
        [_infoView addSubview:classtime];
        classtime.sd_layout
        .leftEqualToView(teacher)
        .topSpaceToView(teacher,20)
        .autoHeightRatio(0);
        [classtime setSingleLineAutoResizeWithMaxWidth:200];
        
        _classTimeLabel = [UILabel new];
        _classTimeLabel.textColor = TITLECOLOR;
        
        [_infoView addSubview:_classTimeLabel];
        _classTimeLabel.sd_layout
        .leftEqualToView(_teacheNameLabel)
        .topEqualToView(classtime)
        .bottomEqualToView(classtime);
        [_classTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 价格*/
        UILabel *price = [UILabel new];
        price.text = @"价        格";
        price.textColor = [UIColor blackColor];
        [_infoView addSubview:price];
        price.sd_layout
        .leftEqualToView(classtime)
        .topSpaceToView(classtime,20)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:200];
        
        _priceLabel = [UILabel new];
        _priceLabel.textColor = TITLECOLOR;
        _priceLabel.sd_layout
        .leftEqualToView(_classTimeLabel)
        .topEqualToView(price)
        .bottomEqualToView(price);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 辅助分割线*/
        _subLine = [[UIView alloc]init];
        [_infoView addSubview:_subLine];
        _subLine.sd_layout
        .leftEqualToView(_infoView)
        .rightEqualToView(_infoView)
        .topSpaceToView(price,20)
        .heightIs(0.5);
        
        
        //分割线2
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = BACKGROUNDGRAY;
        [self addSubview:line2];
        
        line2.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_infoView,0)
        .heightIs(10);
        
        
        ///支付方式选择部分...
        UIView *payView = [[UIView alloc]init];
        payView.backgroundColor = [UIColor whiteColor];
        [self addSubview:payView];
        
        payView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line2,0)
        .heightIs(self.height_sd*0.08*3+1.5);
        
        
        //打横格
        UIView *payline1 = [[UIView alloc]init];
        [payView addSubview:payline1];
        payline1.backgroundColor = SEPERATELINECOLOR;
        payline1.sd_layout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(payView,self.height_sd*0.08)
        .heightIs(0.5);
        
        UIView *payline2 = [[UIView alloc]init];
        [payView addSubview:payline2];
        payline2.backgroundColor = SEPERATELINECOLOR;
        payline2.sd_layout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(payline1,self.height_sd*0.08)
        .heightIs(0.5);
        
        UIView *payline3 = [[UIView alloc]init];
        [payView addSubview:payline3];
        payline3.backgroundColor = SEPERATELINECOLOR;
        payline3.sd_layout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(payline2,self.height_sd*0.08)
        .heightIs(0.5);
        
        
        //微信支付
        UIImageView *wechatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechatPay"]];
        [payView addSubview:wechatImage];
        wechatImage.sd_layout
        .leftSpaceToView(payView,20)
        .topSpaceToView(payView,10)
        .bottomSpaceToView(payline1,10)
        .widthEqualToHeight();
        
        UILabel *wechat = [[UILabel alloc]init];
        wechat.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        wechat.text = @"微信支付";
        wechat.font = [UIFont systemFontOfSize:14];
        [payView addSubview:wechat];
        wechat.sd_layout
        .leftSpaceToView(wechatImage,20)
        .topSpaceToView(payView,10)
        .autoHeightRatio(0);
        [wechat setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *wechatTip = [[UILabel alloc]init];
        wechatTip.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        wechatTip.font = [UIFont systemFontOfSize:13];
        wechatTip.text = @"推荐安装微信5.0及以上版本";
        [payView addSubview:wechatTip];
        
        wechatTip.sd_layout
        .leftEqualToView(wechat)
        .topSpaceToView(wechat,10)
        .autoHeightRatio(0);
        [wechatTip setSingleLineAutoResizeWithMaxWidth:300];
        
        [wechatTip updateLayout];
        
        //分割线布局变化
        payline1.sd_resetLayout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(wechatTip,10)
        .heightIs(0.5);
        [payline1 updateLayout];
        
        payline2.sd_resetLayout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(payline1,payline1.origin_sd.y+0.5)
        .heightIs(0.5);
        [payline2 updateLayout];
       
        payline3.sd_resetLayout
        .leftSpaceToView(payView,15)
        .rightSpaceToView(payView,15)
        .topSpaceToView(payline2,payline1.origin_sd.y+0.5)
        .heightIs(0.5);
        [payline3 updateLayout];
        
        payView.sd_resetLayout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line2,0)
        .heightIs(payline3.origin_sd.y+payline3.height_sd);
        [payView updateLayout];
        
        payline3.hidden = YES;
        

        _wechatButton =[UIButton new];
        [payView addSubview:_wechatButton];
        _wechatButton.sd_layout
        .centerYEqualToView(wechatImage)
        .topSpaceToView(payView,15)
        .bottomSpaceToView(payline1,15)
        .rightSpaceToView(payView,15)
        .widthEqualToHeight();
        _wechatButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_wechatButton setEnlargeEdge:10];
        
        //支付宝
        UIImageView *alipayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aliPay"]];
        [payView addSubview:alipayImage];
        
        alipayImage.sd_layout
        .leftEqualToView(wechatImage)
        .topSpaceToView(payline1,10)
        .bottomSpaceToView(payline2,10)
        .widthEqualToHeight();
        
        UILabel *alipay = [[UILabel alloc]init];
        [payView addSubview:alipay];
        alipay.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        alipay.text = @"支付宝支付";
        alipay.font = [UIFont systemFontOfSize:14];
        alipay.sd_layout
        .leftSpaceToView(alipayImage,20)
        .topSpaceToView(payline1,10)
        .autoHeightRatio(0);
        [alipay setSingleLineAutoResizeWithMaxWidth:100];
        
        
        UILabel *alipayTip = [[UILabel alloc]init];
        alipayTip.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        alipayTip.font = [UIFont systemFontOfSize:13];
        alipayTip.text = @"推荐有支付宝账户的用户使用";
        [payView addSubview:alipayTip];
        
        alipayTip.sd_layout
        .leftEqualToView(alipay)
        .topSpaceToView(alipay,10)
        .bottomSpaceToView(payline2,10);
        [alipayTip setSingleLineAutoResizeWithMaxWidth:300];
        
        
        _alipayButton =[UIButton new];
        [payView addSubview:_alipayButton];
        _alipayButton.sd_layout
        .centerYEqualToView(alipayImage)
        .topSpaceToView(payline1,15)
        .bottomSpaceToView(payline2,15)
        .widthEqualToHeight();
        _alipayButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_alipayButton setEnlargeEdge:10];
        
        
        
        //余额支付
        _balanceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"amountPay"]];
        [payView addSubview:_balanceImage];
        
        _balanceImage.sd_layout
        .leftEqualToView(alipayImage)
        .topSpaceToView(payline2,10)
        .bottomSpaceToView(payline3,10)
        .widthEqualToHeight();
        
        UILabel *balances = [[UILabel alloc]init];
        [payView addSubview:balances];
        balances.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        balances.text = @"支付宝支付";
        balances.font = [UIFont systemFontOfSize:14];
        balances.sd_layout
        .leftSpaceToView(_balanceImage,20)
        .topSpaceToView(payline2,10)
        .autoHeightRatio(0);
        [balances setSingleLineAutoResizeWithMaxWidth:100];

        _balance = [UILabel new];
        _balance.textColor = TITLECOLOR;
        _balance.font = [UIFont systemFontOfSize:13];
        _balance.text = @"当前余额¥0.00元";
        [payView addSubview:_balance];
        _balance.sd_layout
        .leftEqualToView(balances)
        .topSpaceToView(balances,10)
        .bottomSpaceToView(payline3,10);
        [_balance setSingleLineAutoResizeWithMaxWidth:300];
        
        _balanceButton =[UIButton new];
        [payView addSubview:_balanceButton];
        
        _balanceButton.sd_layout
        .centerYEqualToView(_balanceImage)
        .topSpaceToView(payline2,15)
        .bottomSpaceToView(payline3,15)
        .widthEqualToHeight();
        _balanceButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_balanceButton setEnlargeEdge:10];
        
        
//        _balanceLabel = [UILabel new];
//        _balanceLabel.textColor = TITLECOLOR;
//        _balanceLabel.text = @"应付金额";
        
//        [payView addSubview:_balanceLabel];
//        _balanceLabel.sd_layout
//        .topEqualToView(_balance)
//        .bottomEqualToView(_balance)
//        .leftSpaceToView(_balance,2);
//        [_balanceLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        
        //分割线3
        UIView *line3 = [[UIView alloc]init];
        [self addSubview:line3];
        line3.backgroundColor = BACKGROUNDGRAY;
        line3.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(payView,0)
        .heightIs(10);
        
        
        //分割线4
        UIView *line4 = [[UIView alloc]init];
        [self addSubview:line4];
        line4.backgroundColor = BACKGROUNDGRAY;
        line4.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line3,self.height_sd*0.07)
        .bottomEqualToView(self);
        
        UIView *promotionView = [[UIView alloc]init];
        [self addSubview:promotionView];
        promotionView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line3,0)
        .bottomSpaceToView(line4,0);
        
        /* 优惠码确定按钮*/
        _sureButton = [[UIButton alloc]init];
        _sureButton .layer.borderColor = TITLECOLOR.CGColor;
        _sureButton.layer.borderWidth = 0.6;
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:TITLERED forState:UIControlStateNormal];
        [promotionView addSubview:_sureButton];
        _sureButton.sd_layout
        .topSpaceToView(promotionView,10)
        .rightSpaceToView(promotionView,20)
        .bottomSpaceToView(promotionView,10)
        .widthIs(60);
        _sureButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        /* 优惠码输入框*/
        UIView *promotionText = [[UIView alloc]init];
        promotionText.layer.borderColor =TITLECOLOR.CGColor;
        promotionText.layer.borderWidth = 0.6;
        [promotionView addSubview:promotionText];
        promotionText.sd_layout
        .topEqualToView(_sureButton)
        .bottomEqualToView(_sureButton)
        .rightSpaceToView(_sureButton,0)
        .widthIs(self.width_sd/2.0);
        promotionText.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        /* 优惠码输入框*/
        _promotionText = [[UITextField alloc]init];
        [promotionText addSubview:_promotionText];
        _promotionText.sd_layout
        .leftSpaceToView(promotionText,10)
        .rightSpaceToView(promotionText,10)
        .topSpaceToView(promotionText,5)
        .bottomSpaceToView(promotionText,5);
        
        
        /* 优惠码*/
        UILabel *promotion = [[UILabel alloc]init];
        promotion.text = @"输入优惠码";
        promotion.textColor = TITLECOLOR;
        [promotionView addSubview:promotion];
        promotion.sd_layout
        .leftSpaceToView(promotionView,20)
        .centerYEqualToView(promotionText)
        .autoHeightRatio(0);
        [promotion setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 优惠码按钮*/
        _promotionButton = [[UIButton alloc]init];
        [_promotionButton setTitle:@"使用优惠码" forState:UIControlStateNormal];
        [_promotionButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_promotionButton setBackgroundColor:[UIColor whiteColor]];
        
        
        [promotionView addSubview:_promotionButton];
        _promotionButton.sd_layout
        .leftEqualToView(promotionView)
        .rightEqualToView(promotionView)
        .topEqualToView(promotionView)
        .bottomEqualToView(promotionView);
        
        
        /* 支付部分的背景view*/
        UIView *applyView = [[UIView alloc]init];
        applyView.backgroundColor = [UIColor whiteColor];
        [self addSubview:applyView];
        
        applyView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self)
        .heightIs(100);
        
        /* 支付按钮*/
        _applyButton = [[UIButton alloc]init];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
        _applyButton.backgroundColor = BUTTONRED;
        
        [applyView addSubview:_applyButton];
        _applyButton.sd_layout
        .leftSpaceToView(applyView,10)
        .rightSpaceToView(applyView,10)
        .bottomSpaceToView(applyView,10)
        .heightIs(self.height_sd*0.06);
        
        /* 元*/
        UILabel *yuan = [[UILabel alloc]init];
        yuan.text = @"元";
        yuan.textColor = TITLECOLOR;
        [applyView addSubview:yuan];
        yuan.sd_layout
        .bottomSpaceToView(_applyButton,10)
        .rightEqualToView(_applyButton)
        .autoHeightRatio(0);
        [yuan setSingleLineAutoResizeWithMaxWidth:50];
        
        /* 总价*/
        _totalMoneyLabel = [UILabel new];
        _totalMoneyLabel.textColor = BUTTONRED;
        _totalMoneyLabel.font = [UIFont systemFontOfSize:27*ScrenScale];
        [applyView addSubview:_totalMoneyLabel];
        _totalMoneyLabel.sd_layout
        .rightSpaceToView(yuan,10)
        .bottomEqualToView(yuan)
        .autoHeightRatio(0);
        [_totalMoneyLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 应付金额*/
        UILabel *payment = [[UILabel alloc]init];
        payment.text = @"应付金额";
        [applyView addSubview:payment];
        payment.sd_layout
        .rightSpaceToView(_totalMoneyLabel,5)
        .topEqualToView(yuan)
        .bottomEqualToView(yuan);
        [payment setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 优惠金额*/
        _promotionNum= [[UILabel alloc]init];
        _promotionNum.textColor = TITLECOLOR;
        [applyView addSubview:_promotionNum];
        _promotionNum.sd_layout
        .leftEqualToView(_applyButton)
        .bottomEqualToView(payment)
        .autoHeightRatio(0);
        [_promotionNum setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return self;
}

@end
