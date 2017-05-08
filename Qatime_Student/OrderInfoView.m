//
//  OrderInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OrderInfoView.h"

@implementation OrderInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 支付状态图*/
        _statusImage = [[UIImageView alloc]init];
        
        /* 课程名*/
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        /* 次级课程名*/
        _subName = [[UILabel alloc]init];
        _subName.textColor = TITLECOLOR;
        _subName.font = TITLEFONTSIZE;
        
        /* 分割线*/
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = SEPERATELINECOLOR_2;
        
        /* 订单号*/
        UILabel *orderNumber = [[UILabel alloc]init];
        orderNumber.font = TITLEFONTSIZE;
        orderNumber.textColor = TITLECOLOR;
        orderNumber.text = @"订单编号";
        
        _orderNumber= [[UILabel alloc]init];
        _orderNumber.font = TITLEFONTSIZE;
        _orderNumber.textColor = TITLECOLOR;
        
        /* 创建时间*/
        UILabel *creatTime = [[UILabel alloc]init];
        creatTime.font = TITLEFONTSIZE;
        creatTime.textColor = TITLECOLOR;
        creatTime.text = @"创建时间";
        
        _creatTime = [[UILabel alloc]init];
        _creatTime.font = TITLEFONTSIZE;
        _creatTime.textColor = TITLECOLOR;
        
        /* 支付时间*/
        UILabel *payTime = [[UILabel alloc]init];
        payTime.font = TITLEFONTSIZE;
        payTime.textColor = TITLECOLOR;
        payTime.text = @"支付时间";
        
        _payTime = [[UILabel alloc]init];
        _payTime.font = TITLEFONTSIZE;
        _payTime.textColor = TITLECOLOR;
        
        /* 支付方式*/
        UILabel *payType = [[UILabel alloc]init];
        payType.font = TITLEFONTSIZE;
        payType.textColor = TITLECOLOR;
        payType.text = @"支付方式";
        
        _payType  = [[UILabel alloc]init];
        _payType.font = TITLEFONTSIZE;
        _payType.textColor = TITLECOLOR;
        
        /* 支付金额*/
        UILabel *amount = [[UILabel alloc]init];
        amount.font = TITLEFONTSIZE;
        amount.textColor = TITLECOLOR;
        amount.text = @"支付金额";
        
        _amount = [[UILabel alloc]init];
        _amount.font = TITLEFONTSIZE;
        _amount.textColor = TITLECOLOR;
        
        
        /* 取消订单按钮*/
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        _cancelButton.layer.borderColor = TITLECOLOR.CGColor;
        _cancelButton.layer.borderWidth = 1;
        
        /* 付款按钮*/
        _payButton = [[UIButton alloc]init];
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        [_payButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _payButton.layer.borderColor = BUTTONRED.CGColor;
        _payButton.layer.borderWidth = 1;
        
        
        /**不支持退款的提示*/
        _tips = [[UIView alloc]init];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发送失败"]];
        UILabel *label = [[UILabel alloc]init];
        label.font = TEXT_FONTSIZE_MIN;
        label.text = @"该类型课程不支持退款";
        label.textColor = NAVIGATIONRED;
        [_tips addSubview:image];
        [_tips addSubview: label];
        
        //一般不显示,只有已经付款的视频课显示
        _tips.hidden = YES;

        
        /* 布局*/
        [self sd_addSubviews:@[_statusImage,_name,_subName,line,orderNumber,_orderNumber,creatTime,_creatTime,payTime,_payTime,payType,_payType,amount,_amount,_cancelButton,_payButton,_tips]];
        
        /* 状态图*/
        _statusImage.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(self.width_sd*288/720);
        
        /* 课程名*/
        _name.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(_statusImage,10)
        .rightSpaceToView(self,10)
        .autoHeightRatio(0);
        
        /* 其他信息*/
        _subName.sd_layout
        .topSpaceToView(_name,10)
        .leftEqualToView(_name)
        .autoHeightRatio(0);
        [_subName setSingleLineAutoResizeWithMaxWidth:1000];
        
        /* 分割线*/
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_subName,10)
        .heightIs(0.5);
        
        /* 订单号*/
        orderNumber.sd_layout
        .topSpaceToView(line,10)
        .leftSpaceToView(self,10)
        .autoHeightRatio(0);
        [orderNumber setSingleLineAutoResizeWithMaxWidth:300];
        
        _orderNumber.sd_layout
        .topEqualToView(orderNumber)
        .bottomEqualToView(orderNumber)
        .leftSpaceToView(orderNumber,20)
        .rightEqualToView(self);
        _orderNumber.textAlignment = NSTextAlignmentLeft;
        
        
        /* 创建时间*/
        creatTime.sd_layout
        .topSpaceToView(orderNumber,10)
        .leftSpaceToView(self,10)
        .autoHeightRatio(0);
        [creatTime setSingleLineAutoResizeWithMaxWidth:300];
        
        _creatTime.sd_layout
        .topEqualToView(creatTime)
        .bottomEqualToView(creatTime)
        .leftSpaceToView(creatTime,20)
        .rightEqualToView(self);
        _creatTime.textAlignment = NSTextAlignmentLeft;

        /* 支付时间*/
        payTime.sd_layout
        .topSpaceToView(creatTime,10)
        .leftSpaceToView(self,10)
        .autoHeightRatio(0);
        [payTime setSingleLineAutoResizeWithMaxWidth:300];
        
        _payTime.sd_layout
        .topEqualToView(payTime)
        .bottomEqualToView(payTime)
        .leftSpaceToView(payTime,20)
        .rightEqualToView(self);
        _payTime.textAlignment = NSTextAlignmentLeft;

        
        /* 支付方式*/
        payType.sd_layout
        .topSpaceToView(payTime,10)
        .leftSpaceToView(self,10)
        .autoHeightRatio(0);
        [payType setSingleLineAutoResizeWithMaxWidth:300];
        
        _payType.sd_layout
        .topEqualToView(payType)
        .bottomEqualToView(payType)
        .leftSpaceToView(payType,20)
        .rightEqualToView(self);
        _payType.textAlignment = NSTextAlignmentLeft;
        
        /* 支付金额*/
        amount.sd_layout
        .topSpaceToView(payType,10)
        .leftSpaceToView(self,10)
        .autoHeightRatio(0);
        [amount setSingleLineAutoResizeWithMaxWidth:300];
        
        _amount.sd_layout
        .topEqualToView(amount)
        .bottomEqualToView(amount)
        .leftSpaceToView(amount,20)
        .rightEqualToView(self);
        _amount.textAlignment = NSTextAlignmentLeft;

        
        /* 取消订单*/
        _cancelButton.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(amount,20)
        .heightRatioToView(self,0.065)
        .widthIs(self.width_sd/2-20-5);
        _cancelButton.sd_cornerRadius = [NSNumber numberWithInteger:2];
        
        _payButton.sd_layout
        .rightSpaceToView(self,20)
        .topEqualToView(_cancelButton)
        .bottomEqualToView(_cancelButton)
        .widthRatioToView(_cancelButton,1.0);
        _payButton.sd_cornerRadius = [NSNumber numberWithInteger:2];
        
        
        /*不能退款课程的提示*/
        _tips.sd_layout
        .leftSpaceToView(self, 20)
        .topSpaceToView(amount, 20)
        .rightSpaceToView(self, 20)
        .heightRatioToView(self, 0.065);
        
        label.sd_layout
        .centerXEqualToView(_tips)
        .centerYEqualToView(_tips)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        image.sd_layout
        .rightSpaceToView(label, 10)
        .topEqualToView(label)
        .bottomEqualToView(label)
        .widthEqualToHeight();
        [label updateLayout];
        [image updateLayout];
        [_tips updateLayout];

        image.sd_layout
        .leftSpaceToView(_tips, (_tips.width_sd-(image.width_sd+label.width_sd+10))/2);
        
        [image updateLayout];
        label.sd_layout
        .leftSpaceToView(image, 10);
        [label updateLayout];
        
        
    }
    return self;
}

@end
