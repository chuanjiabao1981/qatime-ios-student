//
//  CheckOrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CheckOrderView.h"

@interface CheckOrderView (){
    
    UIView *line;
    
}

@end

@implementation CheckOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 状态*/
        _status = [[UILabel alloc]init];
        _status.font = [UIFont systemFontOfSize:26*ScrenScale];
        
        _statusImage  = [[UIImageView alloc]init];
        
        /* 最新余额*/
        _balance = [[UILabel alloc]init];
        _balance.textColor = TITLECOLOR;
        _balance.font = TEXT_FONTSIZE;
        
        /* 分割线*/
        line = [[UIView alloc]init];
        line. backgroundColor=[UIColor lightGrayColor];
        
        /* 编号*/
        UILabel *number = [[UILabel alloc]init];
        number.font = TEXT_FONTSIZE;
        number.text = @"编        号";
        number.textColor = TITLECOLOR;
        
        _number= [[UILabel alloc]init];
        _number.font = TEXT_FONTSIZE;
        _number.textColor = TITLECOLOR;
        
        /* 充值金额*/
        UILabel *money = [[UILabel alloc]init];
        money.text = @"支付金额";
        money.textColor = TITLECOLOR;
        money.font = TEXT_FONTSIZE;
        
        _chargeMoney= [[UILabel alloc]init];
        _chargeMoney.textColor = TITLECOLOR;
        _chargeMoney.font = TEXT_FONTSIZE;
        
        
        /* 完成按钮*/
        _finishButton = [[UIButton alloc]init];
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        _finishButton.layer.borderWidth =1;
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        _finishButton.titleLabel.font = TEXT_FONTSIZE;
        
        
        
        /* 解释*/
        _explain = [[UILabel alloc]init];
        _explain.backgroundColor = BACKGROUNDGRAY;
        _explain.textColor = TITLECOLOR;
        _explain.text = @"由于当前购买人数较多，需要等待一会儿才能获取充值结果，请稍后进行查询。";
        _explain.numberOfLines = 0;
        _explain.font = TEXT_FONTSIZE;
        
        /* 布局*/
        [self sd_addSubviews:@[_status,_statusImage,_balance,line,number,_number,money,_chargeMoney,_finishButton,_explain]];
        
        _status.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self,self.height_sd/10)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:2000];
        
        _statusImage .sd_layout
        .rightSpaceToView(_status,5)
        .topEqualToView(_status)
        .bottomEqualToView(_status)
        .widthEqualToHeight();
        
        /* 最新余额*/
        
        _balance .sd_layout
        .topSpaceToView(_status,self.height_sd/10)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [_balance setSingleLineAutoResizeWithMaxWidth:2000];
        
        /* 分割线*/
        line.sd_layout
        .topSpaceToView(_balance,20)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0.6);
        
        
        /* 编号*/
        
        number.sd_layout
        .topSpaceToView(line,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200];
        
        _number .sd_layout
        .topEqualToView(number)
        .bottomEqualToView(number)
        .leftSpaceToView(number,20)
        .rightSpaceToView(self,20);
        _number.textAlignment = NSTextAlignmentLeft;
        
        /* 充值金额*/
        
        money.sd_layout
        .leftEqualToView(number)
        .topSpaceToView(number,20)
        .autoHeightRatio(0);
        [money setSingleLineAutoResizeWithMaxWidth:200];
        
        _chargeMoney.sd_layout
        .topEqualToView(money)
        .leftEqualToView(_number)
        .bottomEqualToView(money)
        .rightEqualToView(_number);
        
        
        /* 完成按钮*/
        
        _finishButton.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(_chargeMoney,30)
        .heightRatioToView(self,0.065);
        
        _explain.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topEqualToView(number)
        .bottomSpaceToView(_finishButton,0);
    
        
    }
    return self;
}



@end
