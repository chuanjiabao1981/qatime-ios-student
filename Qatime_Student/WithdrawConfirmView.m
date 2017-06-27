//
//  WithdrawConfirmView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithdrawConfirmView.h"

@implementation WithdrawConfirmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        UIView *content = [[UIView alloc]init];
        [self addSubview:content];
        content.backgroundColor = [UIColor whiteColor];
        content.sd_layout
        .topSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(100);
        
        
        /* 订单号*/
        UILabel *num = [UILabel new];
        num.textColor = TITLECOLOR;
        num.text = @"编        号";
        
        _orderNumber = [UILabel new];
        _orderNumber.textColor = [UIColor blackColor];
        
        /* 时间*/
        UILabel *ordertime = [UILabel new];
        ordertime.textColor = TITLECOLOR;
        ordertime.text = @"时        间";
        
        _time = [UILabel new];
        _time.textColor = [UIColor blackColor];
        
        /* 交易类型*/
        UILabel *kind = [UILabel new];
        kind.textColor = TITLECOLOR;
        kind.text = @"交易类型";
        
        _type = [UILabel new];
        _type.textColor = [UIColor blackColor];
        _type.text = @"账户提现";
        
        /* 提现方式*/
        
        UILabel *way = [UILabel new];
        way.textColor = TITLECOLOR;
        way.text = @"提现方式";

        _method =[UILabel new];
        _method.textColor = [UIColor blackColor];
        _method.text = @"微信";
        
        
        /* 提现金额*/
        UILabel *amount = [UILabel new];
        amount.textColor = TITLECOLOR;
        amount.text = @"提现金额";
        
        _money = [UILabel new];
        _money.textColor = [UIColor blackColor];
        
//        /* 手续费*/
//        UILabel *extra = [UILabel new];
//        extra.textColor = TITLECOLOR;
//        extra.text = @"提现金额";
//        
//        _fee= [UILabel new];
//        _fee.textColor = [UIColor blackColor];

        
        /* 确定按钮*/
        _finishButton = [[UIButton alloc]init];
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        _finishButton.layer.borderWidth = 1.0f;
        [_finishButton setTitle:@"确定" forState:UIControlStateNormal];
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        
        
        /* 布局*/
        
        [self sd_addSubviews:@[content,_finishButton]];
        [content sd_addSubviews:@[num,_orderNumber,ordertime,_time,kind,_type,way,_method,amount,_money]];
        
        /* 订单号*/
        num.sd_layout
        .topSpaceToView(content,20)
        .leftSpaceToView(content,10)
        .autoHeightRatio(0);
        [num setSingleLineAutoResizeWithMaxWidth:300.0];
        
        _orderNumber.sd_layout
        .topEqualToView(num)
        .leftSpaceToView(num,20)
        .bottomEqualToView(num);
        [_orderNumber setSingleLineAutoResizeWithMaxWidth:1000.0];
        
        /* 时间*/
        ordertime.sd_layout
        .topSpaceToView(num,10)
        .leftEqualToView(num)
        .autoHeightRatio(0);
        [ordertime setSingleLineAutoResizeWithMaxWidth:300.0];
        
        _time.sd_layout
        .leftEqualToView(_orderNumber)
        .topEqualToView(ordertime)
        .bottomEqualToView(ordertime);
        [_time setSingleLineAutoResizeWithMaxWidth:1000];
        
        /* 交易类型*/
        kind.sd_layout
        .topSpaceToView(ordertime,10)
        .leftEqualToView(ordertime)
        .autoHeightRatio(0);
        [kind setSingleLineAutoResizeWithMaxWidth:300.0];
        
        _type.sd_layout
        .topEqualToView(kind)
        .bottomEqualToView(kind)
        .leftEqualToView(_time);
        [_type setSingleLineAutoResizeWithMaxWidth:1000];
        
        /* 提现方式*/
        way.sd_layout
        .leftEqualToView(kind)
        .topSpaceToView(kind,10)
        .autoHeightRatio(0);
        [way setSingleLineAutoResizeWithMaxWidth:300.0];
        
        _method.sd_layout
        .leftEqualToView(_type)
        .topEqualToView(way)
        .bottomEqualToView(way);
        [_method setSingleLineAutoResizeWithMaxWidth:1000];
        
        /* 提现金额*/
        amount.sd_layout
        .leftEqualToView(way)
        .topSpaceToView(way,10)
        .autoHeightRatio(0);
        [amount setSingleLineAutoResizeWithMaxWidth:300];
        
        _money.sd_layout
        .leftEqualToView(_method)
        .topEqualToView(amount)
        .bottomEqualToView(amount);
        [_money setSingleLineAutoResizeWithMaxWidth:1000];
        
//        /* 手续费*/
//        extra.sd_layout
//        .leftEqualToView(amount)
//        .topSpaceToView(amount,10)
//        .autoHeightRatio(0);
//        [extra setSingleLineAutoResizeWithMaxWidth:300];
//        
//        _fee.sd_layout
//        .leftEqualToView(_money)
//        .topEqualToView(extra)
//        .bottomEqualToView(extra);
//        [_fee setSingleLineAutoResizeWithMaxWidth:1000];
        
        
        [content setupAutoHeightWithBottomView:amount bottomMargin:20*ScrenScale];
        /* 完成按钮*/
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(content,20*ScrenScale)
        .heightIs(40*ScrenScale320);
        
        
    }
    return self;
}

@end
