//
//  PayConfirmView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PayConfirmView.h"

@implementation PayConfirmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 订单编号*/
        UILabel *number = [UILabel new];
        number.text = @"订单编号";
        number.textColor = TITLECOLOR;
        
        _number = [UILabel new];
        _number.textColor = TITLECOLOR;
        
        
        /*创建时间*/
        UILabel *ordertime = [UILabel new];
        ordertime.text = @"创建时间";
        ordertime.textColor = TITLECOLOR;
        
        _time = [UILabel new];
        _time.textColor = TITLECOLOR;
        
        /*支付方式*/
        UILabel *type = [UILabel new];
        type.text = @"支付方式";
        type.textColor = TITLECOLOR;
        
        _type = [UILabel new];
        _type.textColor = TITLECOLOR;
        
        /*支付金额*/
        UILabel *money = [UILabel new];
        money.text = @"支付金额";
        money.textColor = TITLECOLOR;
        
        _money = [UILabel new];
        _money.textColor = TITLECOLOR;
        
        
        /* 提示*/
        UILabel *tips = [[UILabel alloc]init];
        tips.text = @"请您在24小时内完成支付确认，否则订单将会自动取消。";
        tips.textColor = TITLECOLOR;
        
        /* 确认按钮*/
        _finishButton = [UIButton new];
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        _finishButton.layer.borderWidth = 1.0;
        [_finishButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        /* 布局*/
        [self sd_addSubviews:@[number,_number,ordertime,_time,type,_type,money,_money,tips,_finishButton]];
        
        number.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200.0];
        
        _number.sd_layout
        .leftSpaceToView(number,20)
        .topEqualToView(number)
        .bottomEqualToView(number);
        [_number setSingleLineAutoResizeWithMaxWidth:1000];
        
        ordertime.sd_layout
        .leftEqualToView(number)
        .topSpaceToView(number,20)
        .autoHeightRatio(0);
        [ordertime setSingleLineAutoResizeWithMaxWidth:200];
        
        _time.sd_layout
        .leftEqualToView(_number)
        .topEqualToView(ordertime)
        .bottomEqualToView(ordertime);
        [_time setSingleLineAutoResizeWithMaxWidth:1000];
        
        type.sd_layout
        .leftEqualToView(ordertime)
        .topSpaceToView(ordertime,20)
        .autoHeightRatio(0);
        [type setSingleLineAutoResizeWithMaxWidth:200];
        
        _type.sd_layout
        .leftEqualToView(_time)
        .topEqualToView(type)
        .bottomEqualToView(type);
        [_type setSingleLineAutoResizeWithMaxWidth:1000];
        
        money.sd_layout
        .leftEqualToView(type)
        .topSpaceToView(type,20)
        .autoHeightRatio(0);
        [money setSingleLineAutoResizeWithMaxWidth:200];
        
        _money.sd_layout
        .leftEqualToView(_type)
        .topEqualToView(money)
        .bottomEqualToView(money);
        [_money setSingleLineAutoResizeWithMaxWidth:1000];
        
        tips.sd_layout
        .topSpaceToView(_money,30)
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .autoHeightRatio(0);
        tips.textAlignment = NSTextAlignmentLeft;
        
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(tips,30)
        .heightIs(self.height_sd*0.065);
        
        
        
        
        
        
        
        
        
    }
    return self;
}

@end
