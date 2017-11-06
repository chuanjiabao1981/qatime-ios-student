//
//  OrderView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//


#import "OrderView.h"
#import "UIImageView+WebCache.h"

#define LINESPACE self.height_sd/80.0*ScrenScale

#define InterVal 10*ScrenScale

#define NormalFont [UIFont systemFontOfSize:14*ScrenScale]

#define MineShaft [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]

#define Steel [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]


@implementation OrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //课程信息部分白色背景图
        _infoView = [[UIView alloc]init];
        [self addSubview:_infoView];
        _infoView.backgroundColor = [UIColor whiteColor];
        
        _infoView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(200);
        
        //课程名
        _className = [UILabel new];
        _className.textColor = MineShaft;
        _className.textAlignment = NSTextAlignmentLeft;
        _className.font = [UIFont systemFontOfSize:15*ScrenScale];
        [_infoView addSubview:_className];
        _className.sd_layout
        .leftSpaceToView(_infoView,20)
        .rightSpaceToView(_infoView,20)
        .topSpaceToView(_infoView,10)
        .autoHeightRatio(0);
        
        //分割线1
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = SEPERATELINECOLOR_2;
        [_infoView addSubview:line1];
        line1.sd_layout
        .leftSpaceToView(_infoView,15)
        .rightSpaceToView(_infoView,15)
        .topSpaceToView(_className,10)
        .heightIs(0.5);
        
        //课程类型
        UILabel *type = [[UILabel alloc]init];
        type.text = @"课程类型";
        type.textColor = MineShaft;
        type.font = NormalFont;
        [_infoView addSubview:type];
        
        type.sd_layout
        .topSpaceToView(line1,InterVal)
        .leftSpaceToView(_infoView,20)
        .autoHeightRatio(0);
        [type setSingleLineAutoResizeWithMaxWidth:200];
        
        _classType =[UILabel new];
        _classType.textColor = Steel;
        _classType.font = NormalFont;
        [_infoView addSubview:_classType];
        
        _classType.sd_layout
        .topEqualToView(type)
        .bottomEqualToView(type)
        .leftSpaceToView(type,20);
        [_classType setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 年级*/
        UILabel *grade = [UILabel new];
        grade.text = @"年        级";
        grade.textColor = MineShaft;
        grade.font = NormalFont;
        [_infoView addSubview:grade];
        
        grade.sd_layout
        .leftEqualToView(type)
        .topSpaceToView(type,InterVal)
        .autoHeightRatio(0);
        [grade setSingleLineAutoResizeWithMaxWidth:200];
        
        _gradeLabel = [UILabel new];
        _gradeLabel.textColor = Steel;
        _gradeLabel.font = NormalFont;
        [_infoView addSubview:_gradeLabel];
        
        _gradeLabel.sd_layout
        .leftEqualToView(_classType)
        .topEqualToView(grade)
        .bottomEqualToView(grade);
        [_gradeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 科目*/
        UILabel *subject = [UILabel new];
        subject.text = @"科        目";
        subject.textColor = MineShaft;
        subject.font = NormalFont;
        [_infoView addSubview:subject];
        
        subject.sd_layout
        .leftEqualToView(grade)
        .topSpaceToView(grade,InterVal)
        .autoHeightRatio(0);
        [subject setSingleLineAutoResizeWithMaxWidth:200];
        
        _subjectLabel = [UILabel new];
        _subjectLabel.textColor = Steel;
        _subjectLabel.font = NormalFont;
        [_infoView addSubview:_subjectLabel];
        
        _subjectLabel.sd_layout
        .topEqualToView(subject)
        .bottomEqualToView(subject)
        .leftSpaceToView(subject,20);
        [_subjectLabel setSingleLineAutoResizeWithMaxWidth:200];

        
        /* 老师*/
        UILabel *teacher = [UILabel new];
        teacher.text = @"授课老师";
        teacher.textColor = MineShaft;
        teacher.font = NormalFont;
        [_infoView addSubview:teacher];
        teacher.sd_layout
        .leftEqualToView(subject)
        .topSpaceToView(subject,InterVal)
        .autoHeightRatio(0);
        [teacher setSingleLineAutoResizeWithMaxWidth:200];
        
        _teacheNameLabel = [UILabel new];
        _teacheNameLabel.textColor = Steel;
        _teacheNameLabel.font = NormalFont;
        [_infoView addSubview:_teacheNameLabel];
        
        _teacheNameLabel.sd_layout
        .leftEqualToView(_subjectLabel)
        .topEqualToView(teacher)
        .bottomEqualToView(teacher);
        [_teacheNameLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 课时总数*/
        UILabel *classtime = [UILabel new];
        classtime.text = @"课时总数";
        classtime.textColor = MineShaft;
        classtime.font = NormalFont;
        [_infoView addSubview:classtime];
        classtime.sd_layout
        .leftEqualToView(teacher)
        .topSpaceToView(teacher,InterVal)
        .autoHeightRatio(0);
        [classtime setSingleLineAutoResizeWithMaxWidth:200];
        
        _classTimeLabel = [UILabel new];
        _classTimeLabel.textColor = Steel;
        _classTimeLabel.font = NormalFont;
        
        [_infoView addSubview:_classTimeLabel];
        _classTimeLabel.sd_layout
        .leftEqualToView(_teacheNameLabel)
        .topEqualToView(classtime)
        .bottomEqualToView(classtime);
        [_classTimeLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        /* 价格*/
        UILabel *price = [UILabel new];
        price.text = @"价        格";
        price.textColor = MineShaft;
        price.font = NormalFont;
        [_infoView addSubview:price];
        price.sd_layout
        .leftEqualToView(classtime)
        .topSpaceToView(classtime,InterVal)
        .autoHeightRatio(0);
        [price setSingleLineAutoResizeWithMaxWidth:200];
        
        _priceLabel = [UILabel new];
        _priceLabel.textColor = Steel;
        _priceLabel.font = NormalFont;
        [_infoView addSubview:_priceLabel];
        _priceLabel.sd_layout
        .leftEqualToView(_classTimeLabel)
        .topEqualToView(price)
        .bottomEqualToView(price);
        [_priceLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        [price updateLayout];
        
        /* 改变自身底视图高度*/
        
        [_infoView clearAutoHeigtSettings];
        
        _infoView.sd_layout
        .heightIs(price.bottom_sd+30);
        [_infoView updateLayout];
        
        
        //分割线2
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = BACKGROUNDGRAY;
        [self addSubview:line2];
        
        line2.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(_infoView,0)
        .heightIs(10);
        
        
        ///支付方式选择部分...
        UIView *payView = [[UIView alloc]init];
        payView.backgroundColor = [UIColor whiteColor];
        [self addSubview:payView];
        
        payView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line2,0)
        .heightIs(self.height_sd*0.08+0.5);
        
        //余额支付
        _balanceImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"amountPay"]];
        [payView addSubview:_balanceImage];
        
        _balanceImage.sd_layout
        .leftSpaceToView(payView, 15*ScrenScale)
        .topSpaceToView(payView,10*ScrenScale)
        .bottomSpaceToView(payView,10*ScrenScale)
        .widthEqualToHeight();
        
        UILabel *balances = [[UILabel alloc]init];
        [payView addSubview:balances];
        balances.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        balances.text = @"账户余额";
        balances.font = [UIFont systemFontOfSize:14*ScrenScale];
        balances.sd_layout
        .leftSpaceToView(_balanceImage,20*ScrenScale)
        .topSpaceToView(payView,10*ScrenScale)
        .autoHeightRatio(0);
        [balances setSingleLineAutoResizeWithMaxWidth:100];

        _balance = [UILabel new];
        _balance.textColor = TITLECOLOR;
        _balance.font = [UIFont systemFontOfSize:13*ScrenScale];
        _balance.text = @"当前余额¥0.00元";
        [payView addSubview:_balance];
        _balance.sd_layout
        .leftEqualToView(balances)
        .topSpaceToView(balances,10*ScrenScale)
        .bottomSpaceToView(payView,10*ScrenScale);
        [_balance setSingleLineAutoResizeWithMaxWidth:300];
        
        _balanceButton =[UIButton new];
        [_balanceButton setImage:[UIImage imageNamed:@"selectedCircle"] forState:UIControlStateNormal];
        [payView addSubview:_balanceButton];
        _balanceButton.enabled = NO;
        
        _balanceButton.sd_layout
        .centerYEqualToView(_balanceImage)
        .topSpaceToView(payView,18*ScrenScale)
        .bottomSpaceToView(payView,18*ScrenScale)
        .rightSpaceToView(payView,15*ScrenScale)
        .widthEqualToHeight();
        _balanceButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        [_balanceButton setEnlargeEdge:10];
        
     
        
        //分割线3
        UIView *line3 = [[UIView alloc]init];
        [self addSubview:line3];
        line3.backgroundColor = BACKGROUNDGRAY;
        line3.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(payView,0)
        .heightIs(10);
        
        
        //分割线4
        UIView *line4 = [[UIView alloc]init];
        [self addSubview:line4];
        line4.backgroundColor = BACKGROUNDGRAY;
        line4.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line3,0) //暂时封住优惠码功能
        .bottomEqualToView(self);
        
        UIView *promotionView = [[UIView alloc]init];
        [self addSubview:promotionView];
        promotionView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(line3,0)
        .bottomSpaceToView(line4,0);
        promotionView.hidden = YES;
        
        /* 优惠码确定按钮*/
        _sureButton = [[UIButton alloc]init];
        _sureButton.titleLabel.font = TEXT_FONTSIZE;
        _sureButton .layer.borderColor = TITLECOLOR.CGColor;
        _sureButton.layer.borderWidth = 0.6;
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:TITLERED forState:UIControlStateNormal];
        [promotionView addSubview:_sureButton];
        _sureButton.sd_layout
        .topSpaceToView(promotionView,10*ScrenScale)
        .rightSpaceToView(promotionView,20*ScrenScale)
        .bottomSpaceToView(promotionView,10*ScrenScale)
        .widthIs(60*ScrenScale);
        _sureButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        /* 优惠码输入框*/
        UIView *promotionText = [[UIView alloc]init];
        promotionText.layer.borderColor =TITLECOLOR.CGColor;
        promotionText.layer.borderWidth = 0.6;
        [promotionView addSubview:promotionText];
        promotionText.sd_layout
        .topEqualToView(_sureButton)
        .bottomEqualToView(_sureButton)
        .rightSpaceToView(_sureButton,0)
        .widthIs(self.width_sd/2.0);
        promotionText.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        /* 优惠码输入框*/
        _promotionText = [[UITextField alloc]init];
        [promotionText addSubview:_promotionText];
        _promotionText.sd_layout
        .leftSpaceToView(promotionText,10*ScrenScale)
        .rightSpaceToView(promotionText,10*ScrenScale)
        .topSpaceToView(promotionText,5*ScrenScale)
        .bottomSpaceToView(promotionText,5*ScrenScale);
        

        /* 优惠码*/
        UILabel *promotion = [[UILabel alloc]init];
        promotion.text = @"输入优惠码";
        promotion.textColor = TITLECOLOR;
        promotion.font = TEXT_FONTSIZE;
        [promotionView addSubview:promotion];
        promotion.sd_layout
        .leftSpaceToView(promotionView,20*ScrenScale)
        .centerYEqualToView(promotionText)
        .autoHeightRatio(0);
        [promotion setSingleLineAutoResizeWithMaxWidth:100];
        
        
        /* 优惠码按钮*/
        _promotionButton = [[UIButton alloc]init];
        _promotionButton.titleLabel.font = TEXT_FONTSIZE;
    
        [_promotionButton setTitle:@"使用优惠码" forState:UIControlStateNormal];
        [_promotionButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
        [_promotionButton setBackgroundColor:[UIColor whiteColor]];
        
        
        [promotionView addSubview:_promotionButton];
        _promotionButton.sd_layout
        .leftEqualToView(promotionView)
        .rightEqualToView(promotionView)
        .topEqualToView(promotionView)
        .bottomEqualToView(promotionView);
        
        
        /* 支付部分的背景view*/
        UIView *applyView = [[UIView alloc]init];
        applyView.backgroundColor = [UIColor whiteColor];
        [self addSubview:applyView];
        
        applyView.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self)
        .heightIs(100);
        
        /* 支付按钮*/
        _applyButton = [[UIButton alloc]init];
        _applyButton.titleLabel.font = TITLEFONTSIZE;
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyButton setTitle:@"立即支付" forState:UIControlStateNormal];
        _applyButton.backgroundColor = BUTTONRED;
        
        [applyView addSubview:_applyButton];
        _applyButton.sd_layout
        .leftSpaceToView(applyView,10)
        .rightSpaceToView(applyView,10)
        .bottomSpaceToView(applyView,10)
        .heightIs(self.height_sd*0.06);
        
        /* 元*/
        UILabel *yuan = [[UILabel alloc]init];
        yuan.font = TITLEFONTSIZE;
        yuan.text = @"元";
        yuan.textColor = TITLECOLOR;
        [applyView addSubview:yuan];
        yuan.sd_layout
        .bottomSpaceToView(_applyButton,10)
        .rightEqualToView(_applyButton)
        .autoHeightRatio(0);
        [yuan setSingleLineAutoResizeWithMaxWidth:50];
        
        /* 总价*/
        _totalMoneyLabel = [UILabel new];
        
        _totalMoneyLabel.textColor = BUTTONRED;
        _totalMoneyLabel.font = [UIFont systemFontOfSize:27*ScrenScale];
        [applyView addSubview:_totalMoneyLabel];
        _totalMoneyLabel.sd_layout
        .rightSpaceToView(yuan,10)
        .bottomEqualToView(yuan)
        .autoHeightRatio(0);
        [_totalMoneyLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        /* 应付金额*/
        UILabel *payment = [[UILabel alloc]init];
        payment.font = TITLEFONTSIZE;
        payment.text = @"应付金额";
        [applyView addSubview:payment];
        payment.sd_layout
        .rightSpaceToView(_totalMoneyLabel,5)
        .topEqualToView(yuan)
        .bottomEqualToView(yuan);
        [payment setSingleLineAutoResizeWithMaxWidth:100];
        
        /* 优惠金额*/
        _promotionNum= [[UILabel alloc]init];
        _promotionNum.textColor = TITLECOLOR;
        [applyView addSubview:_promotionNum];
        _promotionNum.sd_layout
        .leftEqualToView(_applyButton)
        .bottomEqualToView(payment)
        .autoHeightRatio(0);
        [_promotionNum setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return self;
}

- (void)setupLiveClassData:(TutoriumListInfo *)tutorium{
    
    _subjectLabel.text = tutorium.subject;
    _className.text = tutorium.name;
    _gradeLabel.text = tutorium.grade;
    _teacheNameLabel.text = tutorium.teacher_name;
    _classTimeLabel.text = [NSString stringWithFormat:@"共%@课",tutorium.video_lessons_count];
    if ([tutorium.current_price containsString:@"."]) {
        
        if ([tutorium.status isEqualToString:@"teaching"]||[tutorium.status isEqualToString:@"pause"]||[tutorium.status isEqualToString:@"closed"]) {
            //已开课的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元(插班价)",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"missed"]||[tutorium.status isEqualToString:@"init"]||[tutorium.status isEqualToString:@"ready"]){
            //未开课
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"finished"]||[tutorium.status isEqualToString:@"billing"]||[tutorium.status isEqualToString:@"completed"]){
            //结束的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"published"]){
            //招生中
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }else{
            //其他状态
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }
        
    }else{
        
        if ([tutorium.status isEqualToString:@"teaching"]||[tutorium.status isEqualToString:@"pause"]||[tutorium.status isEqualToString:@"closed"]) {
            //已开课的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元(插班价)",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"missed"]||[tutorium.status isEqualToString:@"init"]||[tutorium.status isEqualToString:@"ready"]){
            //未开课
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"finished"]||[tutorium.status isEqualToString:@"billing"]||[tutorium.status isEqualToString:@"completed"]){
            //结束的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"published"]){
            //招生中
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else{
            //其他状态
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }
        
    }

}

- (void)setupInteractionData:(OneOnOneClass *)interaction{
    
    _subjectLabel.text = interaction.subject;
    _className.text = interaction.current_lesson_name;
    _gradeLabel.text = interaction.grade;
    
    interaction.teacherNameString = @"".mutableCopy;
    for (NSDictionary *teacher in interaction.teachers) {
        
        [interaction.teacherNameString appendString:[NSString stringWithFormat:@"%@/",teacher[@"name"]]];
    }
   
    _teacheNameLabel.text =  [interaction.teacherNameString substringWithRange:NSMakeRange(0, interaction.teacherNameString.length-1)];
    _classTimeLabel.text = interaction.lessons_count;
    
    if ([interaction.price containsString:@"."]) {
        _priceLabel.text = [NSString stringWithFormat:@"¥%@元",interaction.price];
        _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",interaction.price];
        
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",interaction.price];
        _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",interaction.price];
        
    }
    
}

- (void)setupExclusiveClassData:(TutoriumListInfo *)tutorium{
    
    _subjectLabel.text = tutorium.subject;
    _className.text = tutorium.name;
    _gradeLabel.text = tutorium.grade;
    _teacheNameLabel.text = tutorium.teacher_name;
    _classTimeLabel.text = [NSString stringWithFormat:@"共%@课",tutorium.events_count];
    if ([tutorium.current_price containsString:@"."]) {
        
        if ([tutorium.status isEqualToString:@"teaching"]||[tutorium.status isEqualToString:@"pause"]||[tutorium.status isEqualToString:@"closed"]) {
            //已开课的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元(插班价)",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@(插班价)",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"missed"]||[tutorium.status isEqualToString:@"init"]||[tutorium.status isEqualToString:@"ready"]){
            //未开课
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"finished"]||[tutorium.status isEqualToString:@"billing"]||[tutorium.status isEqualToString:@"completed"]){
            //结束的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"published"]){
            //招生中
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }else{
            //其他状态
            _priceLabel.text = [NSString stringWithFormat:@"¥%@元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@",tutorium.price];
        }
        
    }else{
        
        if ([tutorium.status isEqualToString:@"teaching"]||[tutorium.status isEqualToString:@"pause"]||[tutorium.status isEqualToString:@"closed"]) {
            //已开课的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元(插班价)",tutorium.current_price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00(插班价)",tutorium.current_price];
        }else if ([tutorium.status isEqualToString:@"missed"]||[tutorium.status isEqualToString:@"init"]||[tutorium.status isEqualToString:@"ready"]){
            //未开课
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"finished"]||[tutorium.status isEqualToString:@"billing"]||[tutorium.status isEqualToString:@"completed"]){
            //结束的
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else if ([tutorium.status isEqualToString:@"published"]){
            //招生中
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }else{
            //其他状态
            _priceLabel.text = [NSString stringWithFormat:@"¥%@.00元",tutorium.price];
            _totalMoneyLabel.text =[NSString stringWithFormat:@"¥%@.00",tutorium.price];
        }
    }
}

@end
