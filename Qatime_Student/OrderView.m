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
        
        /* 订单项目滚动视图*/
        _scrollView = [[UIView alloc]init];
//        _scrollView.contentSize = CGSizeMake(self.width_sd,self.height_sd);
        
        /* 课程名*/
        UILabel *className = [UILabel new];
        className.text = @"课程名称";
        className.textColor = TITLECOLOR;
        
        _className = [UILabel new];
        _className.textColor = TITLECOLOR;
        
        
        UILabel *classinfo = [UILabel new];
        classinfo.text = @"课程信息";
        classinfo.textColor = TITLECOLOR;

        /* 课程图*/
        _classImage  = [[UIImageView alloc]init];
        
        /* 科目*/
        UILabel *subject = [UILabel new];
        subject.text = @"科目类型:";
        subject.textColor = TITLECOLOR;
        
        _subjectLabel = [UILabel new];
        _subjectLabel.textColor = TITLECOLOR;
        
        /* 年级*/
        UILabel *grade = [UILabel new];
        grade.text = @"年级类型:";
        grade.textColor = TITLECOLOR;
        
        _gradeLabel = [UILabel new];
        _gradeLabel.textColor = TITLECOLOR;
        
        /* 老师*/
        UILabel *teacher = [UILabel new];
        teacher.text = @"授课老师:";
        teacher.textColor = TITLECOLOR;
        
        _teacheNameLabel = [UILabel new];
        _teacheNameLabel.textColor = TITLECOLOR;

        /* 课时总数*/
        UILabel *classtime = [UILabel new];
        classtime.text = @"课时总数:";
        classtime.textColor = TITLECOLOR;
        
        _classTimeLabel = [UILabel new];
        _classTimeLabel.textColor = TITLECOLOR;
        
        
        /* 开课时间*/
        UILabel *startTime = [UILabel new];
        startTime.text = @"开课时间:";
        startTime.textColor = TITLECOLOR;
        
        _startTimeLabel = [UILabel new];
        _startTimeLabel.textColor = TITLECOLOR;

        
        /* 开课时间*/
        UILabel *endTime = [UILabel new];
        endTime.text = @"结束时间:";
        endTime.textColor = TITLECOLOR;
        
        _endTimeLabel = [UILabel new];
        _endTimeLabel.textColor = TITLECOLOR;
        
        
        /* 课程状态*/
        UILabel *stats = [UILabel new];
        stats.text = @"当前状态:";
        stats.textColor = TITLECOLOR;
        
        _statusLabel = [UILabel new];
        _statusLabel.textColor = TITLECOLOR;
        
        
        /* 授课方式*/
        UILabel *type = [UILabel new];
        type.text = @"授课方式:";
        type.textColor = TITLECOLOR;
        
        _typeLabel = [UILabel new];
        _typeLabel.textColor = TITLECOLOR;
        
        
        /* 价格*/
        UILabel *price = [UILabel new];
        price.text = @"价    格:";
        price.textColor = TITLECOLOR;
        
        _priceLabel = [UILabel new];
        _priceLabel.textColor = TITLECOLOR;
        
        
        /* 分割线*/
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        
        /* 支付view*/
        UIView *chosenView = [[UIView alloc]init];
        
        
        /* 支付方式*/
        UILabel *payWay = [UILabel new];
        payWay.text = @"支付方式";
        payWay.textColor = TITLECOLOR;
        
        /* 微信支付*/
        _wechatButton =[UIButton new];
        _wechatButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _wechatButton.layer.borderWidth = 0.8;
        
        UIImageView *wechatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat"]];
        
        UILabel *wechat = [UILabel new];
        wechat.textColor = TITLECOLOR;
        wechat.text = @"微信支付";
        
        /* 支付宝支付*/
        _alipayButton =[UIButton new];
        _alipayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _alipayButton.layer.borderWidth = 0.8;
        
        UIImageView *alipayImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alipay"]];
        
        UILabel *alipay = [UILabel new];
        alipay.textColor = TITLECOLOR;
        alipay.text = @"支付宝支付";

        
        
        /* 余额支付*/
        _balanceButton =[UIButton new];
        _balanceButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _balanceButton.layer.borderWidth = 0.8;
        
        _balanceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"money"]];
        
        _balance = [UILabel new];
        _balance.textColor = TITLECOLOR;
        _balance.text = @"余额";
        
        _balanceLabel = [UILabel new];
        _balanceLabel.textColor = TITLECOLOR;
        
        
        /* 支付部分视图*/
        UIView *payView = [[UIView alloc]init];
        payView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        
        UILabel *price_tot = [[UILabel alloc]init];
        price_tot.text = @"应付金额";
        price_tot.textColor = TITLECOLOR;
        
        UILabel *yuan = [[UILabel alloc]init];
        yuan.text = @"元";
        yuan.textColor = TITLECOLOR;

        _totalMoneyLabel = [UILabel new];
        _totalMoneyLabel.textColor = [UIColor blackColor];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:27];
        
        /* 支付按钮*/
        _applyButton = [[UIButton alloc]init];
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyButton setTitle:@"立即支付" forState:UIControlStateNormal];
        _applyButton.backgroundColor = BUTTONRED;
        
        
        
        /* 布局*/
        
        
        [self sd_addSubviews:@[_scrollView,chosenView]];
        
        
        [_scrollView sd_addSubviews:@[className,_className,classinfo,_classImage,subject,_subjectLabel,grade,_gradeLabel,teacher,_teacheNameLabel,classtime,_classTimeLabel,startTime,_startTimeLabel,endTime,_endTimeLabel,stats,_statusLabel,type,_typeLabel,price,_priceLabel,line]];
        [chosenView sd_addSubviews:@[payWay,_wechatButton,wechatImage,wechat,_alipayButton,alipayImage,alipay,_balanceButton,_balanceImage,_balance,_balanceLabel,payView]];
        
        [payView sd_addSubviews:@[price_tot,yuan,_totalMoneyLabel,_applyButton]];
        

        
        /* 滑动图*/
        _scrollView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(self.height_sd*2/3.0);
        
        
        /* 选择view*/
        chosenView.sd_layout
        .topSpaceToView(_scrollView,0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        
        
        /* 课程名*/
        className.sd_layout
        .leftSpaceToView(_scrollView,10)
        .topSpaceToView(_scrollView,10)
        .autoHeightRatio(0);
        [className setSingleLineAutoResizeWithMaxWidth:500];
        
        _className .sd_layout
        .leftSpaceToView(className,20)
        .rightSpaceToView(_scrollView,10)
        .topEqualToView(className)
        .autoHeightRatio(0);
        _className.numberOfLines = 0;
        
        /* 课程信息*/
        classinfo.sd_layout
        .leftEqualToView(className)
        .topSpaceToView(className,LINESPACE)
        .autoHeightRatio(0);
        [classinfo setSingleLineAutoResizeWithMaxWidth:500];
        
        /* 课程图*/
        _classImage.sd_layout
        .topEqualToView(classinfo)
        .leftEqualToView(_className)
        .widthRatioToView(_scrollView,1/3.5)
        .heightEqualToWidth();
        
        /* 科目*/
        subject.sd_layout
        .topSpaceToView(_classImage,LINESPACE)
        .leftEqualToView(_classImage)
        .autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:500];
        
        _subjectLabel.sd_layout
        .leftSpaceToView(subject,10)
        .topEqualToView(subject)
        .autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:500];
        

        /* 年级*/
        grade.sd_layout
        .topSpaceToView(subject,LINESPACE)
        .leftEqualToView(subject)
        .autoHeightRatio(0);
        [grade setSingleLineAutoResizeWithMaxWidth:500];
        
        _subjectLabel.sd_layout
        .leftSpaceToView(grade,10)
        .topEqualToView(grade)
        .autoHeightRatio(0);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:500];

        
        /* 授课老师*/
        teacher.sd_layout
        .topSpaceToView(grade,LINESPACE)
        .leftEqualToView(grade)
        .autoHeightRatio(0);
        [teacher setSingleLineAutoResizeWithMaxWidth:500];
        
        _teacheNameLabel.sd_layout
        .leftSpaceToView(teacher,10)
        .topEqualToView(teacher)
        .autoHeightRatio(0);
        [_teacheNameLabel setSingleLineAutoResizeWithMaxWidth:500];

        /* 课时总数*/
        classtime.sd_layout
        .topSpaceToView(teacher,LINESPACE)
        .leftEqualToView(teacher)
        .autoHeightRatio(0);
        [classtime setSingleLineAutoResizeWithMaxWidth:500];
        
        _classTimeLabel.sd_layout
        .leftSpaceToView(classtime,10)
        .topEqualToView(classtime)
        .autoHeightRatio(0);
        [_classTimeLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        /* 开课时间*/
        startTime.sd_layout
        .topSpaceToView(classtime,LINESPACE)
        .leftEqualToView(_classImage)
        .autoHeightRatio(0);
        [startTime setSingleLineAutoResizeWithMaxWidth:500];
        
        _startTimeLabel.sd_layout
        .leftSpaceToView(startTime,10)
        .topEqualToView(startTime)
        .autoHeightRatio(0);
        [_startTimeLabel setSingleLineAutoResizeWithMaxWidth:500];
        

        /* 结束时间*/
        endTime.sd_layout
        .topSpaceToView(startTime,LINESPACE)
        .leftEqualToView(startTime)
        .autoHeightRatio(0);
        [endTime setSingleLineAutoResizeWithMaxWidth:500];
        
        _endTimeLabel.sd_layout
        .leftSpaceToView(endTime,10)
        .topEqualToView(endTime)
        .autoHeightRatio(0);
        [_endTimeLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        /* 当前状态*/
        stats.sd_layout
        .topSpaceToView(endTime,LINESPACE)
        .leftEqualToView(endTime)
        .autoHeightRatio(0);
        [stats setSingleLineAutoResizeWithMaxWidth:500];
        
        _statusLabel.sd_layout
        .leftSpaceToView(stats,10)
        .topEqualToView(stats)
        .autoHeightRatio(0);
        [_statusLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        /* 授课方式*/
        type.sd_layout
        .topSpaceToView(stats,LINESPACE)
        .leftEqualToView(stats)
        .autoHeightRatio(0);
        [type setSingleLineAutoResizeWithMaxWidth:500];
        
        _typeLabel.sd_layout
        .leftSpaceToView(type,10)
        .topEqualToView(type)
        .autoHeightRatio(0);
        [_typeLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        /* 价格*/
        price.sd_layout
        .topSpaceToView(type,LINESPACE)
        .leftEqualToView(type)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:500];
        
        _priceLabel.sd_layout
        .leftSpaceToView(price,10)
        .topEqualToView(price)
        .autoHeightRatio(0);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:500];
        
        [_priceLabel updateLayout];
        
        line.sd_layout
        .leftEqualToView(_scrollView)
        .rightEqualToView(_scrollView)
        .bottomEqualToView(_scrollView)
        .heightIs(0.6);
        
        
        /* 支付方式*/
        payWay.sd_layout
        .leftSpaceToView(chosenView,10)
        .topSpaceToView(chosenView,10)
        .autoHeightRatio(0);
        [payWay setSingleLineAutoResizeWithMaxWidth:500];
        
        
        /* 微信*/
        
        _wechatButton.sd_layout
        .leftSpaceToView(payWay,20)
        .topEqualToView(payWay)
        .bottomEqualToView(payWay)
        .widthEqualToHeight();
        _wechatButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        wechatImage.sd_layout
        .leftSpaceToView(_wechatButton,10)
        .centerYEqualToView(_wechatButton)
        .heightRatioToView(_wechatButton,1.0)
        .widthEqualToHeight();
        
        wechat.sd_layout
        .leftSpaceToView(wechatImage,5)
        .topEqualToView(payWay)
        .bottomEqualToView(payWay);
        [wechat setSingleLineAutoResizeWithMaxWidth:200.0];
        
        /* 支付宝*/
        
        _alipayButton.sd_layout
        .leftEqualToView(_wechatButton)
        .topSpaceToView(_wechatButton,10)
        .rightEqualToView(_wechatButton)
        .heightRatioToView(_wechatButton,1.0);
        _alipayButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        alipayImage.sd_layout
        .leftSpaceToView(_alipayButton,10)
        .centerYEqualToView(_alipayButton)
        .heightRatioToView(_alipayButton,1.0)
        .widthEqualToHeight();
        
        alipay.sd_layout
        .leftSpaceToView(alipayImage,5)
        .topEqualToView(alipayImage)
        .bottomEqualToView(alipayImage);
        [alipay setSingleLineAutoResizeWithMaxWidth:200.0];
        
        /* 余额支付*/
        
        _balanceButton.sd_layout
        .leftEqualToView(_alipayButton)
        .topSpaceToView(_alipayButton,10)
        .rightEqualToView(_alipayButton)
        .heightRatioToView(_alipayButton,1.0);
        _balanceButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        _balanceImage.sd_layout
        .leftSpaceToView(_balanceButton,10)
        .centerYEqualToView(_balanceButton)
        .heightRatioToView(_balanceButton,1.0)
        .widthEqualToHeight();
        
        _balance.sd_layout
        .leftSpaceToView(_balanceImage,5)
        .topEqualToView(_balanceImage)
        .bottomEqualToView(_balanceImage);
        [_balance setSingleLineAutoResizeWithMaxWidth:500];
        
        _balanceLabel.sd_layout
        .topEqualToView(_balance)
        .bottomEqualToView(_balance)
        .leftSpaceToView(_balance,3);
        [_balanceLabel setSingleLineAutoResizeWithMaxWidth:500.0];

        
        
        /* 价格支付部分*/
        payView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(chosenView)
        .topSpaceToView(_balance,10);
        
        /* 确认按钮*/
        _applyButton.sd_layout
        .leftSpaceToView(payView,10)
        .rightSpaceToView(payView,10)
        .bottomSpaceToView(payView,10)
        .heightRatioToView(payView,0.4);
        
        /* 总价*/
        _totalMoneyLabel.sd_layout
        .centerXEqualToView(payView)
        .topSpaceToView(payView,5)
        .bottomSpaceToView(_applyButton,5);
        [_totalMoneyLabel setSingleLineAutoResizeWithMaxWidth:1000];
        
        price_tot.sd_layout
        .leftSpaceToView(payView,10)
        .centerYEqualToView(_totalMoneyLabel)
        .autoHeightRatio(0);
        [price_tot setSingleLineAutoResizeWithMaxWidth:500];
        
        yuan.sd_layout
        .centerYEqualToView(_totalMoneyLabel)
        .rightSpaceToView(payView,10)
        .autoHeightRatio(0);
        [yuan setSingleLineAutoResizeWithMaxWidth:200];
        


        
        
        
    }
    return self;
}

@end
