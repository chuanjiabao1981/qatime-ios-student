//
//  DrawBackView.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DrawBackView.h"
#import "UITextView+Placeholder.h"

@implementation DrawBackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        /* 交易号*/
        UILabel *number = [[UILabel alloc]init];
        number.font = TITLEFONTSIZE;
        number.text = @"订单编号";
        
        _number = [[UILabel alloc]init];
        _number.font = TITLEFONTSIZE;
        
        /* 课程名/商品名称*/
        UILabel *classname = [[UILabel alloc]init];
        classname.font = TITLEFONTSIZE;
        classname.text = @"课程名称";

        _className = [[UILabel alloc]init];
        _className.font = TITLEFONTSIZE;
        
        /* 课程进度*/
        UILabel *progress = [[UILabel alloc]init];
        progress.font = TITLEFONTSIZE;
        progress.text = @"可退课时";
        
        _progress = [[UILabel alloc]init];
        _progress.font = TITLEFONTSIZE;
        
        /* 商品总价*/
        UILabel *price = [[UILabel alloc]init];
        price.font = TITLEFONTSIZE;
        price.text = @"订单总价";
        
        _price = [[UILabel alloc]init];
        _price.font = TITLEFONTSIZE;
        
        /* 已消费金额*/
        UILabel *paidPrice = [[UILabel alloc]init];
        paidPrice.font = TITLEFONTSIZE;
        paidPrice.text = @"已消费额";
        
        _paidPrice = [[UILabel alloc]init];
        _paidPrice.font = TITLEFONTSIZE;
        
        /* 退款方式*/
        UILabel *drawBackWay = [[UILabel alloc]init];
        drawBackWay.font = TITLEFONTSIZE;
        drawBackWay.text = @"退款方式";
        
        _drawBackWay = [[UILabel alloc]init];
        _drawBackWay.font = TITLEFONTSIZE;
        
        /* 可退金额*/
        UILabel *enabeldrawBackPrice = [[UILabel alloc]init];
        enabeldrawBackPrice.font = TITLEFONTSIZE ;
        enabeldrawBackPrice.text = @"可退金额";
        
        _enableDrawbackPrice = [[UILabel alloc]init];
        _enableDrawbackPrice.font = TITLEFONTSIZE;
        
        /* 退款原因*/
        _reason = [[UITextView alloc]init];
        _reason.layer.borderColor = TITLECOLOR.CGColor;
        _reason.layer.borderWidth = 0.6;
        _reason.placeholder = @"请输入退款原因(20字以内)";
        _reason.placeholderLabel.font = [UIFont systemFontOfSize:16*ScrenScale];
        
        /* 说明*/
        UILabel *tips = [[UILabel alloc]init];
        tips.font = TITLEFONTSIZE;
        tips.text = @"说明：退款过程中您将不能进行此课程的学习!";
        
       
        /* 提交按钮*/
        _finishButton = [[UIButton alloc]init];
        [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
        _finishButton.layer.borderWidth =1;
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:[UIColor whiteColor]];
        
        
        /* 布局*/
        [self sd_addSubviews:@[number,_number,classname,_className,progress,_progress,price,_price,paidPrice,_paidPrice,drawBackWay,_drawBackWay,enabeldrawBackPrice,_enableDrawbackPrice,_reason,tips,_finishButton]];
        
        /* 商品名称*/
        number.sd_layout
        .topSpaceToView(self,20)
        .leftSpaceToView(self,20)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200];
        
        _number.sd_layout
        .topEqualToView(number)
        .leftSpaceToView(number,20)
        .bottomEqualToView(number)
        .rightSpaceToView(self,20);
        _number.textAlignment = NSTextAlignmentLeft;
        
        /* 商品名称*/
        classname.sd_layout
        .leftEqualToView(number)
        .topSpaceToView(number,20)
        .autoHeightRatio(0);
        [classname setSingleLineAutoResizeWithMaxWidth:200];
        
        _className.sd_layout
        .topEqualToView(classname)
        .leftSpaceToView(classname,20)
        .bottomEqualToView(classname)
        .rightSpaceToView(self,20);
        _className.textAlignment = NSTextAlignmentLeft;
        
        /* 课程进度*/
        progress.sd_layout
        .leftEqualToView(classname)
        .topSpaceToView(classname,20)
        .autoHeightRatio(0);
        [progress setSingleLineAutoResizeWithMaxWidth:200];
        
        _progress.sd_layout
        .topEqualToView(progress)
        .leftSpaceToView(progress,20)
        .bottomEqualToView(progress)
        .rightSpaceToView(self,20);
        _progress.textAlignment = NSTextAlignmentLeft;
        
        /* 商品价格*/
        price.sd_layout
        .leftEqualToView(progress)
        .topSpaceToView(progress,20)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:200];
        
        _price.sd_layout
        .topEqualToView(price)
        .leftSpaceToView(price,20)
        .bottomEqualToView(price)
        .rightSpaceToView(self,20);
        _price.textAlignment = NSTextAlignmentLeft;
        
        /* 已消费金额*/
        paidPrice.sd_layout
        .leftEqualToView(price)
        .topSpaceToView(price,20)
        .autoHeightRatio(0);
        [paidPrice setSingleLineAutoResizeWithMaxWidth:200];
        
        _paidPrice.sd_layout
        .topEqualToView(paidPrice)
        .leftSpaceToView(paidPrice,20)
        .bottomEqualToView(paidPrice)
        .rightSpaceToView(self,20);
        _paidPrice.textAlignment = NSTextAlignmentLeft;
        
        /* 退款方式*/
        drawBackWay.sd_layout
        .leftEqualToView(paidPrice)
        .topSpaceToView(paidPrice,20)
        .autoHeightRatio(0);
        [drawBackWay setSingleLineAutoResizeWithMaxWidth:200];
        
        _drawBackWay.sd_layout
        .topEqualToView(drawBackWay)
        .leftSpaceToView(drawBackWay,20)
        .bottomEqualToView(drawBackWay)
        .rightSpaceToView(self,20);
        _drawBackWay.textAlignment = NSTextAlignmentLeft;
        
        /* 可退金额*/
        enabeldrawBackPrice.sd_layout
        .leftEqualToView(drawBackWay)
        .topSpaceToView(drawBackWay,20)
        .autoHeightRatio(0);
        [enabeldrawBackPrice setSingleLineAutoResizeWithMaxWidth:200];
        
        _enableDrawbackPrice.sd_layout
        .topEqualToView(enabeldrawBackPrice)
        .leftSpaceToView(enabeldrawBackPrice,20)
        .bottomEqualToView(enabeldrawBackPrice)
        .rightSpaceToView(self,20);
        _enableDrawbackPrice.textAlignment = NSTextAlignmentLeft;

        /* 退款原因*/
        _reason.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(enabeldrawBackPrice,20)
        .autoHeightRatio(1/3.0);
        _reason.sd_cornerRadius = [NSNumber numberWithInteger:1];
        
        _finishButton.sd_layout
        .leftEqualToView(_reason)
        .rightEqualToView(_reason)
        .topSpaceToView(_reason,20)
        .heightRatioToView(self,0.07);
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
    }
    return self;
}



@end
