//
//  CheckChargeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CheckChargeView.h"

@interface CheckChargeView (){
    
    
    UIView *line;
}

@end

@implementation CheckChargeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.font = [UIFont systemFontOfSize:26*ScrenScale];
        [self addSubview:_status];
        
        _status.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self,self.height_sd/10)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:2000];
        
        _statusImage  = [[UIImageView alloc]init];
        [self addSubview:_statusImage];
        
        _statusImage .sd_layout
        .rightSpaceToView(_status,5)
        .topEqualToView(_status)
        .bottomEqualToView(_status)
        .widthEqualToHeight();
        
        /* 最新余额*/
        _balance = [[UILabel alloc]init];
        _balance.textColor = TITLECOLOR;
        [self addSubview:_balance];
    
        _balance .sd_layout
        .topSpaceToView(_status,self.height_sd/10)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [_balance setSingleLineAutoResizeWithMaxWidth:2000];

        
        /* 分割线*/
        line = [[UIView alloc]init];
        line. backgroundColor=[UIColor lightGrayColor];
        [self addSubview:line];
        line.sd_layout
        .topSpaceToView(_balance,20)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0.6);
        
        /* 编号*/
        UILabel *number = [[UILabel alloc]init];
        number.text = @"编        号";
        number.textColor = TITLECOLOR;
        [self addSubview:number];
        
        number.sd_layout
        .topSpaceToView(line,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _number= [[UILabel alloc]init];
        _number.textColor = TITLECOLOR;
        [self addSubview:_number];
        
        _number .sd_layout
        .topEqualToView(number)
        .bottomEqualToView(number)
        .leftSpaceToView(number,20)
        .rightSpaceToView(self,20);
        _number.textAlignment = NSTextAlignmentLeft;


        /* 充值金额*/
        UILabel *money = [[UILabel alloc]init];
        money.text = @"充值金额";
        money.textColor = TITLECOLOR;
        [self addSubview:money];
        
        money.sd_layout
        .leftEqualToView(number)
        .topSpaceToView(number,20)
        .autoHeightRatio(0);
        [money setSingleLineAutoResizeWithMaxWidth:200];
        
        _chargeMoney= [[UILabel alloc]init];
        _chargeMoney.textColor = TITLECOLOR;
        [self addSubview:_chargeMoney];
        
        _chargeMoney.sd_layout
        .topEqualToView(money)
        .leftEqualToView(_number)
        .bottomEqualToView(money)
        .rightEqualToView(_number);

        
        /* 完成按钮*/
        _finishButton = [[UIButton alloc]init];
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        _finishButton.layer.borderWidth =1;
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:[UIColor whiteColor]];
        [self addSubview: _finishButton];
        
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_chargeMoney,30)
        .heightRatioToView(self,0.065);
        
        /* 解释*/
        _explain = [[UILabel alloc]init];
        _explain.backgroundColor = [UIColor whiteColor];
        _explain.textColor = TITLECOLOR;
        _explain.text = @"由于当前购买人数较多，需要等待一会儿才能获取充值结果，请稍后进行查询。";
        _explain.numberOfLines = 0;
        
        [self addSubview:_explain];
        
        _explain.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topEqualToView(number)
        .bottomSpaceToView(_finishButton,0);
        
        
    }
    return self;
}

@end
