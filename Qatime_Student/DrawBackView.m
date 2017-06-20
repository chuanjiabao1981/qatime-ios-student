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
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        UIView *content = [[UIView alloc]init];
        [self addSubview:content];
        content.backgroundColor = [UIColor whiteColor];
        content.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(100);
        
        /* 交易号*/
        UILabel *number = [[UILabel alloc]init];
        number.font = TEXT_FONTSIZE;
        number.text = @"订单编号";
        [content addSubview:number];
        number.sd_layout
        .topSpaceToView(content,10*ScrenScale)
        .leftSpaceToView(content,10*ScrenScale)
        .autoHeightRatio(0);
        [number setSingleLineAutoResizeWithMaxWidth:200];
        
        _number = [[UILabel alloc]init];
        _number.font = TEXT_FONTSIZE;
        _number.textColor = TITLECOLOR;
        [content addSubview:_number];
        _number.sd_layout
        .topEqualToView(number)
        .leftSpaceToView(number,20*ScrenScale)
        .bottomEqualToView(number)
        .rightSpaceToView(content,20);
        _number.textAlignment = NSTextAlignmentLeft;
        
        /* 课程名/商品名称*/
        UILabel *classname = [[UILabel alloc]init];
        classname.font = TEXT_FONTSIZE;
        classname.text = @"课程名称";
        [content addSubview:classname];
        /* 商品名称*/
        classname.sd_layout
        .leftEqualToView(number)
        .topSpaceToView(number,15*ScrenScale)
        .autoHeightRatio(0);
        [classname setSingleLineAutoResizeWithMaxWidth:200];
        
        _className = [[UILabel alloc]init];
        _className.font = TEXT_FONTSIZE;
        _className.textColor = TITLECOLOR;
        [content addSubview:_className];
        _className.sd_layout
        .topEqualToView(classname)
        .leftSpaceToView(classname,20*ScrenScale)
        .bottomEqualToView(classname)
        .rightSpaceToView(content,20);
        _className.textAlignment = NSTextAlignmentLeft;
        
        /* 课程进度*/
        UILabel *progress = [[UILabel alloc]init];
        progress.font = TEXT_FONTSIZE;
        progress.text = @"可退课时";
        [content addSubview:progress];
        /* 课程进度*/
        progress.sd_layout
        .leftEqualToView(classname)
        .topSpaceToView(classname,15*ScrenScale)
        .autoHeightRatio(0);
        [progress setSingleLineAutoResizeWithMaxWidth:200];
        
        _progress = [[UILabel alloc]init];
        _progress.font = TEXT_FONTSIZE;
        _progress.textColor = TITLECOLOR;
        [content addSubview:_progress];
        _progress.sd_layout
        .topEqualToView(progress)
        .leftSpaceToView(progress,20*ScrenScale)
        .bottomEqualToView(progress)
        .rightSpaceToView(content,20);
        _progress.textAlignment = NSTextAlignmentLeft;
        
        /* 商品总价*/
        UILabel *price = [[UILabel alloc]init];
        price.font = TEXT_FONTSIZE;
        price.text = @"订单总价";
        [content addSubview:price];
        /* 商品价格*/
        price.sd_layout
        .leftEqualToView(progress)
        .topSpaceToView(progress,15*ScrenScale)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:200];
        
        _price = [[UILabel alloc]init];
        _price.font = TEXT_FONTSIZE;
        _price.textColor = TITLECOLOR;
        [content addSubview:_price];
        _price.sd_layout
        .topEqualToView(price)
        .leftSpaceToView(price,20*ScrenScale)
        .bottomEqualToView(price)
        .rightSpaceToView(content,20);
        _price.textAlignment = NSTextAlignmentLeft;
        
        
        /* 已消费金额*/
        UILabel *paidPrice = [[UILabel alloc]init];
        paidPrice.font = TEXT_FONTSIZE;
        paidPrice.text = @"已消费额";
        [content addSubview:paidPrice];
        /* 已消费金额*/
        paidPrice.sd_layout
        .leftEqualToView(price)
        .topSpaceToView(price,15*ScrenScale)
        .autoHeightRatio(0);
        [paidPrice setSingleLineAutoResizeWithMaxWidth:200];
        
        _paidPrice = [[UILabel alloc]init];
        _paidPrice.font = TEXT_FONTSIZE;
        _paidPrice.textColor = TITLECOLOR;
        [content addSubview:_paidPrice];
        _paidPrice.sd_layout
        .topEqualToView(paidPrice)
        .leftSpaceToView(paidPrice,20*ScrenScale)
        .bottomEqualToView(paidPrice)
        .rightSpaceToView(content,20);
        _paidPrice.textAlignment = NSTextAlignmentLeft;
        
        /* 退款方式*/
        UILabel *drawBackWay = [[UILabel alloc]init];
        drawBackWay.font = TEXT_FONTSIZE;
        drawBackWay.text = @"退款方式";
        [content addSubview:drawBackWay];
        /* 退款方式*/
        drawBackWay.sd_layout
        .leftEqualToView(paidPrice)
        .topSpaceToView(paidPrice,15*ScrenScale)
        .autoHeightRatio(0);
        [drawBackWay setSingleLineAutoResizeWithMaxWidth:200];
        
        _drawBackWay = [[UILabel alloc]init];
        _drawBackWay.font = TEXT_FONTSIZE;
        _drawBackWay.textColor = TITLECOLOR;
        [content addSubview:_drawBackWay];
        _drawBackWay.sd_layout
        .topEqualToView(drawBackWay)
        .leftSpaceToView(drawBackWay,20*ScrenScale)
        .bottomEqualToView(drawBackWay)
        .rightSpaceToView(content,20);
        _drawBackWay.textAlignment = NSTextAlignmentLeft;
        
        /* 可退金额*/
        UILabel *enabeldrawBackPrice = [[UILabel alloc]init];
        enabeldrawBackPrice.font = TEXT_FONTSIZE ;
        enabeldrawBackPrice.text = @"可退金额";
        [content addSubview:enabeldrawBackPrice];
        
        /* 可退金额*/
        enabeldrawBackPrice.sd_layout
        .leftEqualToView(drawBackWay)
        .topSpaceToView(drawBackWay,15*ScrenScale)
        .autoHeightRatio(0);
        [enabeldrawBackPrice setSingleLineAutoResizeWithMaxWidth:200];
        
        _enableDrawbackPrice = [[UILabel alloc]init];
        _enableDrawbackPrice.font = TEXT_FONTSIZE;
        _enableDrawbackPrice.textColor = TITLECOLOR;
        [content addSubview:_enableDrawbackPrice];
        _enableDrawbackPrice.sd_layout
        .topEqualToView(enabeldrawBackPrice)
        .leftSpaceToView(enabeldrawBackPrice,20*ScrenScale)
        .bottomEqualToView(enabeldrawBackPrice)
        .rightSpaceToView(content,20);
        _enableDrawbackPrice.textAlignment = NSTextAlignmentLeft;
        
        //分割线1
        UIView *line1 = [[UIView alloc]init];
        [content addSubview: line1];
        line1.backgroundColor = SEPERATELINECOLOR_2;
        line1.sd_layout
        .leftSpaceToView(content, 10*ScrenScale)
        .rightSpaceToView(content, 10*ScrenScale)
        .topSpaceToView(enabeldrawBackPrice, 10)
        .heightIs(0.5);
        
        /* 退款原因*/
        UILabel *reason = [[UILabel alloc]init];
        [content addSubview: reason];
        reason.font = TEXT_FONTSIZE;
        reason.text = @"退款原因";
        reason.sd_layout
        .leftEqualToView(enabeldrawBackPrice)
        .topSpaceToView(line1, 20*ScrenScale)
        .autoHeightRatio(0);
        [reason setSingleLineAutoResizeWithMaxWidth:200];
        
        _reason = [[UILabel alloc]init];
        [content addSubview:_reason];
        _reason.font = TEXT_FONTSIZE;
        _reason.textColor = TITLECOLOR;
        _reason.sd_layout
        .centerYEqualToView(reason)
        .autoHeightRatio(0)
        .leftEqualToView(_enableDrawbackPrice);
        [_reason setSingleLineAutoResizeWithMaxWidth:400];
        
        _arrow = [[UIButton alloc]init];
        [_arrow setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        [content addSubview:_arrow];
        _arrow.sd_layout
        .centerYEqualToView(reason)
        .rightSpaceToView(content, 20*ScrenScale320)
        .heightRatioToView(reason, 0.6)
        .widthEqualToHeight();
        [_arrow setEnlargeEdge:30];
        
        
        //第二个分割线
        UIView *line2 = [[UIView alloc]init];
        [content addSubview:line2];
        line2.backgroundColor = SEPERATELINECOLOR_2;
        line2.sd_layout
        .leftEqualToView(line1)
        .rightEqualToView(line1)
        .topSpaceToView(reason, 20*ScrenScale)
        .heightIs(0.5);
        
    
        /* 说明*/
        UILabel *tips = [[UILabel alloc]init];
        tips.font = [UIFont systemFontOfSize:13*[UIScreen mainScreen].bounds.size.width/414.0];
        tips.textColor = TITLECOLOR;
        tips.text = @"退款说明：\n1.退款过程中您将不能进行此课程的学习；\n2.请仔细核对退款信息后提交。";
        [content addSubview:tips];
        tips.sd_layout
        .leftEqualToView(reason)
        .topSpaceToView(line2, 10*ScrenScale)
        .rightSpaceToView(content, 0)
        .autoHeightRatio(0);
        
        [content setupAutoHeightWithBottomView:tips bottomMargin:10];
        
        
        /* 提交按钮*/
        _finishButton = [[UIButton alloc]init];
        _finishButton.titleLabel.font = TEXT_FONTSIZE;
        [_finishButton setTitle:@"提交" forState:UIControlStateNormal];
        _finishButton.layer.borderWidth =1;
        _finishButton.layer.borderColor = BUTTONRED.CGColor;
        [_finishButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        
        [self addSubview:_finishButton];
        
        _finishButton.sd_layout
        .leftSpaceToView(self, 20)
        .rightSpaceToView(self, 20)
        .topSpaceToView(content, 20)
        .heightIs(40*ScrenScale);
        
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        
        //电话帮助
        _phoneTips = [[UILabel alloc]init];
        [self addSubview:_phoneTips];
        _phoneTips.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"遇到问题请拨打客服电话 400-838-8010"];
        [str addAttributes:@{NSFontAttributeName:TEXT_FONTSIZE,NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, 11)];
        [str addAttributes:@{NSFontAttributeName:TEXT_FONTSIZE,NSForegroundColorAttributeName:[UIColor blueColor]} range:NSMakeRange(11, 13)];
        _phoneTips.attributedText = str;
        
        _phoneTips.sd_layout
        .bottomSpaceToView(self, 20)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .autoHeightRatio(0);
        
        _phoneTips.userInteractionEnabled = YES;
        
        
    }
    return self;
}



@end
