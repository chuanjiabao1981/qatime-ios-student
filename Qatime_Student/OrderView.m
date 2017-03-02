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
        
        /* 课程名*/
        UILabel *className = [UILabel new];
        className.text = @"课程名称";
        className.textColor = TITLECOLOR;
        [self addSubview:className];
        className.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [className setSingleLineAutoResizeWithMaxWidth:100];
        
        _className = [UILabel new];
        _className.textColor = TITLECOLOR;
        _className.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(className,30)
        .topEqualToView(className)
        .bottomEqualToView(className)
        .rightSpaceToView(self,20);
        
        
        UILabel *classinfo = [UILabel new];
        classinfo.text = @"课程信息";
        classinfo.textColor = TITLECOLOR;
        [self addSubview:classinfo];
        classinfo.sd_layout
        .leftEqualToView(className)
        .topSpaceToView(className,20)
        .autoHeightRatio(0);
        [classinfo setSingleLineAutoResizeWithMaxWidth:100];
        

        /* 课程图*/
        _classImage  = [[UIImageView alloc]init];
        [self addSubview:_classImage];
        
        _classImage.sd_layout
        .leftEqualToView(_className)
        .topEqualToView(classinfo)
        .widthRatioToView(self,1/3.0)
        .autoHeightRatio(10/16.0);
        
        /* 科目*/
        UILabel *subject = [UILabel new];
        subject.text = @"科目类型:";
        subject.textColor = TITLECOLOR;
        [self addSubview:subject];
        
        subject.sd_layout
        .leftEqualToView(_classImage)
        .topSpaceToView(_classImage,10)
        .autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:100];
        
        _subjectLabel = [UILabel new];
        _subjectLabel.textColor = TITLECOLOR;
        [self addSubview:_subjectLabel];
        _subjectLabel.sd_layout
        .leftSpaceToView(subject,10)
        .topEqualToView(subject)
        .bottomEqualToView(subject);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 年级*/
        UILabel *grade = [UILabel new];
        grade.text = @"年级类型:";
        grade.textColor = TITLECOLOR;
        [self addSubview:grade];
        grade.sd_layout
        .leftEqualToView(subject)
        .topSpaceToView(subject,10)
        .autoHeightRatio(0);
        [grade setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _gradeLabel = [UILabel new];
        _gradeLabel.textColor = TITLECOLOR;
        [self addSubview:_gradeLabel];
        _gradeLabel.sd_layout
        .leftEqualToView(_subjectLabel)
        .topEqualToView(grade)
        .bottomEqualToView(grade);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
        
        /* 老师*/
        UILabel *teacher = [UILabel new];
        teacher.text = @"授课老师:";
        teacher.textColor = TITLECOLOR;
        [self addSubview:teacher];
        teacher.sd_layout
        .leftEqualToView(grade)
        .topSpaceToView(grade,10)
        .autoHeightRatio(0);
        [teacher setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _teacheNameLabel = [UILabel new];
        _teacheNameLabel.textColor = TITLECOLOR;
        [self addSubview:_teacheNameLabel];
        _teacheNameLabel.sd_layout
        .leftEqualToView(_gradeLabel)
        .topEqualToView(teacher)
        .bottomEqualToView(teacher);
        [_teacheNameLabel setSingleLineAutoResizeWithMaxWidth:100];

        /* 课时总数*/
        UILabel *classtime = [UILabel new];
        classtime.text = @"课时总数:";
        classtime.textColor = TITLECOLOR;
        [self addSubview:classtime];
        classtime.sd_layout
        .leftEqualToView(teacher)
        .topSpaceToView(teacher,10)
        .autoHeightRatio(0);
        [classtime setSingleLineAutoResizeWithMaxWidth:100];
        
        _classTimeLabel = [UILabel new];
        _classTimeLabel.textColor = TITLECOLOR;
        
        [self addSubview:_classTimeLabel];
        _classTimeLabel.sd_layout
        .leftEqualToView(_teacheNameLabel)
        .topEqualToView(classtime)
        .bottomEqualToView(classtime);
        [_classTimeLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 开课时间*/
        UILabel *startTime = [UILabel new];
        startTime.text = @"开课时间:";
        startTime.textColor = TITLECOLOR;
        [self addSubview:startTime];
        startTime.sd_layout
        .leftEqualToView(classtime)
        .topSpaceToView(classtime,10)
        .autoHeightRatio(0);
        [startTime setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _startTimeLabel = [UILabel new];
        _startTimeLabel.textColor = TITLECOLOR;
        [self addSubview: _startTimeLabel];
        _startTimeLabel.sd_layout
        .leftEqualToView(_classTimeLabel)
        .topEqualToView(startTime)
        .bottomEqualToView(startTime);
        [_startTimeLabel setSingleLineAutoResizeWithMaxWidth:100];

        /* 开课时间*/
        UILabel *endTime = [UILabel new];
        endTime.text = @"结束时间:";
        endTime.textColor = TITLECOLOR;
        [self addSubview:endTime];
        
        endTime.sd_layout
        .leftEqualToView(startTime)
        .topSpaceToView(startTime,10)
        .autoHeightRatio(0);
        [endTime setSingleLineAutoResizeWithMaxWidth:100];
        
        _endTimeLabel = [UILabel new];
        _endTimeLabel.textColor = TITLECOLOR;
        [self addSubview:_endTimeLabel];
        _endTimeLabel.sd_layout
        .leftSpaceToView(endTime,10)
        .topEqualToView(endTime)
        .bottomEqualToView(endTime);
        [_endTimeLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 课程状态*/
        UILabel *stats = [UILabel new];
        stats.text = @"当前状态:";
        stats.textColor = TITLECOLOR;
        [self addSubview:stats];
        
        stats.sd_layout
        .leftEqualToView(endTime)
        .topSpaceToView(endTime,10)
        .autoHeightRatio(0);
        [stats setSingleLineAutoResizeWithMaxWidth:100];
        
        _statusLabel = [UILabel new];
        _statusLabel.textColor = TITLECOLOR;
        [self addSubview:_statusLabel];
        _statusLabel.sd_layout
        .leftSpaceToView(stats,10)
        .topEqualToView(stats)
        .bottomEqualToView(stats);
        [_statusLabel setSingleLineAutoResizeWithMaxWidth:100];

        
        
        /* 授课方式*/
        UILabel *type = [UILabel new];
        type.text = @"授课方式:";
        type.textColor = TITLECOLOR;
        [self addSubview:type];
        type.sd_layout
        .leftEqualToView(stats)
        .topSpaceToView(stats,10)
        .autoHeightRatio(0);
        [type setSingleLineAutoResizeWithMaxWidth:100];
        
        _typeLabel = [UILabel new];
        _typeLabel.textColor = TITLECOLOR;
        _typeLabel.sd_layout
        .leftSpaceToView(type,10)
        .topEqualToView(type)
        .bottomEqualToView(type);
        [_typeLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 价格*/
        UILabel *price = [UILabel new];
        price.text = @"价        格:";
        price.textColor = TITLECOLOR;
        [self addSubview:price];
        price.sd_layout
        .leftEqualToView(type)
        .topSpaceToView(type,10)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:100];
        
        
        _priceLabel = [UILabel new];
        _priceLabel.textColor = TITLECOLOR;
        _priceLabel.sd_layout
        .leftSpaceToView(price,10)
        .topEqualToView(price)
        .bottomEqualToView(price);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 分割线*/
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line];
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(price,10)
        .heightIs(0.5);
        
        /* 支付view*/
//        UIView *chosenView = [[UIView alloc]init];
    
        /* 支付方式*/
        UILabel *payWay = [UILabel new];
        payWay.text = @"支付方式";
        payWay.textColor = TITLECOLOR;
        [self addSubview:payWay];
        payWay.sd_layout
        .leftEqualToView(classinfo)
        .topSpaceToView(line,10)
        .autoHeightRatio(0);
        [payWay setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 微信支付*/
        _wechatButton =[UIButton new];
        _wechatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _wechatButton.layer.borderWidth = 0.8;
        [self addSubview:_wechatButton];
        _wechatButton.sd_layout
        .leftEqualToView(price)
        .topEqualToView(payWay)
        .bottomEqualToView(payWay)
        .widthEqualToHeight();
        _wechatButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_wechatButton setEnlargeEdge:10];
        
        UIImageView *wechatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat"]];
        [self addSubview:wechatImage];
        wechatImage.sd_layout
        .topEqualToView(_wechatButton)
        .leftSpaceToView(_wechatButton,5)
        .bottomEqualToView(_wechatButton)
        .widthEqualToHeight();
        
        
        UILabel *wechat = [UILabel new];
        wechat.textColor = TITLECOLOR;
        wechat.text = @"微信支付";
        [self addSubview:wechat];
        wechat.sd_layout
        .leftSpaceToView(wechatImage,2)
        .topEqualToView(wechatImage)
        .bottomEqualToView(wechatImage);
        [wechat setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 支付宝支付*/
        _alipayButton =[UIButton new];
        _alipayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _alipayButton.layer.borderWidth = 0.8;
        [self addSubview:_alipayButton];
        _alipayButton.sd_layout
        .topSpaceToView(_wechatButton,10)
        .leftEqualToView(_wechatButton)
        .rightEqualToView(_wechatButton)
        .heightEqualToWidth();
        _alipayButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
         [_alipayButton setEnlargeEdge:10];
//        _alipayButton.hidden = YES;
        
        UIImageView *alipayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alipay"]];
        [self addSubview:alipayImage];
        alipayImage.sd_layout
        .topEqualToView(_alipayButton)
        .bottomEqualToView(_alipayButton)
        .leftEqualToView(wechatImage)
        .rightEqualToView(wechatImage);
//        alipayImage.hidden = YES;
        
        UILabel *alipay = [UILabel new];
        alipay.textColor = TITLECOLOR;
        alipay.text = @"支付宝支付";
        [self addSubview:alipay];
        alipay.sd_layout
        .leftEqualToView(wechat)
        .topEqualToView(alipayImage)
        .bottomEqualToView(alipayImage);
        [alipay setSingleLineAutoResizeWithMaxWidth:100];
//        alipay.hidden = YES;

        /* 余额支付*/
        _balanceButton =[UIButton new];
        _balanceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _balanceButton.layer.borderWidth = 0.8;
        [self addSubview:_balanceButton];
        _balanceButton.sd_layout
        .leftEqualToView(_alipayButton)
        .topSpaceToView(_alipayButton,10)
        .rightEqualToView(_alipayButton)
        .heightEqualToWidth();
        _balanceButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_balanceButton setEnlargeEdge:10];
        
        _balanceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money"]];
        [self addSubview:_balanceImage];
        _balanceImage.sd_layout
        .leftEqualToView(alipayImage)
        .rightEqualToView(alipayImage)
        .topEqualToView(_balanceButton)
        .bottomEqualToView(_balanceButton);
        
        _balance = [UILabel new];
        _balance.textColor = TITLECOLOR;
        _balance.text = @"余额";
        [self addSubview:_balance];
        _balance.sd_layout
        .leftEqualToView(alipay)
        .topEqualToView(_balanceImage)
        .bottomEqualToView(_balanceImage);
        [_balance setSingleLineAutoResizeWithMaxWidth:180];
        
        /* 分割线2*/
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line2];
        line2.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_balance,10)
        .heightIs(0.5);
        
        /* 分割线3*/
        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = SEPERATELINECOLOR;
        [self addSubview:line3];
        line3.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line2,self.height_sd*0.07)
        .heightIs(0.5);
        
        /* 优惠码确定按钮*/
        _sureButton = [[UIButton alloc]init];
        [self addSubview:_sureButton];
        _sureButton.sd_layout
        .topSpaceToView(line2,10)
        .rightSpaceToView(self,20)
        .bottomSpaceToView(line3,10)
        .autoHeightRatio(1/1.5);
        
        
        
        /* 优惠码输入框*/
        UILabel *promotion = [[UILabel alloc]init];
        promotion.text = @"输入优惠码";
        promotion.textColor = TITLECOLOR;
        [self addSubview:promotion];
        promotion.sd_layout
        .leftEqualToView(payWay)
        
        
        
        
        
        /* 优惠码按钮*/
        _promotionButton = [[UIButton alloc]init];
        [_promotionButton setTitle:@"使用优惠码" forState:UIControlStateNormal];
        [_promotionButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        [self addSubview:_promotionButton];
        _promotionButton.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line2,0)
        .heightIs(self.height_sd*0.07);
        
        
        
        
        
        
        
        
        
        
        
        _balanceLabel = [UILabel new];
        _balanceLabel.textColor = TITLECOLOR;
        
        
        
        /* 支付部分视图*/
        UIView *payView = [[UIView alloc]init];
        payView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        
        UILabel *price_tot = [[UILabel alloc]init];
        price_tot.text = @"课程价格";
        price_tot.textColor = TITLECOLOR;
        
        UILabel *yuan = [[UILabel alloc]init];
        yuan.text = @"元";
        yuan.textColor = TITLECOLOR;

        _totalMoneyLabel = [UILabel new];
        _totalMoneyLabel.textColor = [UIColor blackColor];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:27*ScrenScale];
        
        /* 支付按钮*/
        _applyButton = [[UIButton alloc]init];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
        _applyButton.backgroundColor = BUTTONRED;
        
        
        

        


        
        
        
    }
    return self;
}

@end
