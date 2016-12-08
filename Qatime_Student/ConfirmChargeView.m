//
//  ConfirmChargeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ConfirmChargeView.h"

@implementation ConfirmChargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 编号*/
        
        _number = [[UILabel alloc]init];
        _number.textColor = [UIColor blackColor];
        
        UILabel *num = [UILabel new];
        num.textColor = TITLECOLOR;
        num.text = @"编    号";
        
        /* 时间*/
        
        _time = [UILabel new];
        _time .textColor = [UIColor blackColor];
        
        UILabel  *time = [[UILabel alloc]init];
        time.textColor = TITLECOLOR;
        time.text = @"时    间";
        
        
        /* 交易类型*/
        
        _charge_type = [UILabel new];
        _charge_type .textColor = [UIColor blackColor];
        
        UILabel  *charge = [UILabel new];
        charge.textColor = TITLECOLOR;
        charge.text = @"交易类型";

        
        /* 交易方式 */
        
        _pay_type = [UILabel new];
        _pay_type .textColor = [UIColor blackColor];
        
        UILabel  *paytype = [UILabel new];
        paytype.textColor = TITLECOLOR;
        paytype.text = @"交易方式";

        
        
        /* 交易金额*/
        
        _money = [UILabel new];
        _money .textColor = [UIColor blackColor];
        
        UILabel  *mon = [UILabel new];
        mon.textColor = TITLECOLOR;
        mon.text = @"交易金额";
        
        /* 支付按钮*/

        _payButton = [[UIButton alloc]init];
        _payButton.layer.borderColor = BUTTONRED.CGColor;
        _payButton.layer.borderWidth = 1;
        [_payButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_payButton setTitle:@"支付" forState:UIControlStateNormal];
        
        [self sd_addSubviews:@[num,_number,time,_time,charge,_charge_type,paytype,_pay_type,mon,_money,_payButton]];
        
        
        /* 布局*/
        num.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        
        [num setSingleLineAutoResizeWithMaxWidth:300];
        
        _number.sd_layout
        .leftSpaceToView(num,10)
        .topEqualToView(num)
        .rightSpaceToView(self,20)
        .bottomEqualToView(num);
        _number.textAlignment = NSTextAlignmentLeft;
        
        time .sd_layout
        .leftEqualToView(num)
        .topSpaceToView(num,20)
        .autoHeightRatio(0);
        [time setSingleLineAutoResizeWithMaxWidth:400];
        
        _time.sd_layout
        .leftSpaceToView(time,10)
        .topEqualToView(time)
        .rightSpaceToView(self,20)
        .bottomEqualToView(time);
        _time.textAlignment = NSTextAlignmentLeft;

        
        charge .sd_layout
        .leftEqualToView(time)
        .topSpaceToView(time,15)
        .autoHeightRatio(0);
        [charge setSingleLineAutoResizeWithMaxWidth:400];
        
        _charge_type.sd_layout
        .leftSpaceToView(charge,10)
        .topEqualToView(charge)
        .rightSpaceToView(self,20)
        .bottomEqualToView(charge);
        _charge_type.textAlignment = NSTextAlignmentLeft;

        
        
        paytype.sd_layout
        .leftEqualToView(charge)
        .topSpaceToView(charge,15)
        .autoHeightRatio(0);
        [paytype setSingleLineAutoResizeWithMaxWidth:400];
        
        _pay_type.sd_layout
        .leftSpaceToView(paytype,10)
        .topEqualToView(paytype)
        .rightSpaceToView(self,20)
        .bottomEqualToView(paytype);
        _pay_type.textAlignment = NSTextAlignmentLeft;
        
        
        
        mon.sd_layout
        .leftEqualToView(paytype)
        .topSpaceToView(paytype,15)
        .autoHeightRatio(0);
        [mon setSingleLineAutoResizeWithMaxWidth:400];
        
        _money.sd_layout
        .leftSpaceToView(mon,10)
        .topEqualToView(mon)
        .rightSpaceToView(self,20)
        .bottomEqualToView(mon);
        _money.textAlignment = NSTextAlignmentLeft;


        
        
        _payButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_money,30)
        .heightRatioToView(self,0.065);
        _payButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        
    }
    return self;
}



@end
