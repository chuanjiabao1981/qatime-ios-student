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
        line.backgroundColor = TITLECOLOR;
        
        /* 订单号*/
        UILabel *orderNumber = [[UILabel alloc]init];
        orderNumber.font = TITLEFONTSIZE;
        orderNumber.textColor = TITLECOLOR;
        
        _orderNumber= [[UILabel alloc]init];
        _orderNumber.font = TITLEFONTSIZE;
        _orderNumber.textColor = TITLECOLOR;
        
        /* 创建时间*/
        UILabel *creatTime = [[UILabel alloc]init];
        creatTime.font = TITLEFONTSIZE;
        creatTime.textColor = TITLECOLOR;
        
        _creatTime = [[UILabel alloc]init];
        _creatTime.font = TITLEFONTSIZE;
        _creatTime.textColor = TITLECOLOR;
        
        /* 支付时间*/
        UILabel *payTime = [[UILabel alloc]init];
        payTime.font = TITLEFONTSIZE;
        payTime.textColor = TITLECOLOR;
        
        _payTime = [[UILabel alloc]init];
        _payTime.font = TITLEFONTSIZE;
        _payTime.textColor = TITLECOLOR;
        
        /* 支付方式*/
        UILabel *payType = [[UILabel alloc]init];
        payType.font = TITLEFONTSIZE;
        payType.textColor = TITLECOLOR;
        
        _payType  = [[UILabel alloc]init];
        _payType.font = TITLEFONTSIZE;
        _payType.textColor = TITLECOLOR;
        
        /* 支付金额*/
        UILabel *amount = [[UILabel alloc]init];
        amount.font = TITLEFONTSIZE;
        amount.textColor = TITLECOLOR;
        
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
        
        
        /* 布局*/
        [self sd_addSubviews:@[_statusImage,_name,_subName,line,orderNumber,_orderNumber,creatTime,_creatTime,payTime,_payTime,payType,_payType,amount,_amount,_cancelButton,_payButton]];
        
        /* 状态图*/
        
        
        
        
        
        
        
        
    }
    return self;
}

@end
