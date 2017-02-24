//
//  MultiFilterView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/4.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MultiFilterView.h"

@interface MultiFilterView (){
    
    
}

@end


@implementation MultiFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        /* 高价view*/
        UIView *highPriceContent =[[UIView alloc]init];
        [self addSubview:highPriceContent];
        highPriceContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
        highPriceContent.layer.borderWidth = 0.6f;
        highPriceContent.sd_layout
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .widthRatioToView(self,1/3.5f)
        .heightRatioToView(self,0.1f);
        highPriceContent.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        highPriceContent.hidden = YES;
        
        /*高价输入框*/
        _highPrice = [[UITextField alloc]init];
        [highPriceContent addSubview:_highPrice];
        _highPrice.textAlignment = NSTextAlignmentCenter;
        _highPrice.sd_layout.leftSpaceToView(highPriceContent,5).topSpaceToView(highPriceContent,0).bottomSpaceToView(highPriceContent,0).widthRatioToView(highPriceContent,4/5.0f);
        _highPrice.keyboardType=UIKeyboardTypeNumberPad;
        _highPrice.hidden=YES;
        
        /* 元2*/
        UILabel *yuan2=[[UILabel alloc]init];
        [highPriceContent addSubview:yuan2];
        [yuan2 setText:NSLocalizedString(@"元", nil)];
        [yuan2 setTextColor:[UIColor blackColor]];
        yuan2.sd_layout.rightSpaceToView(highPriceContent,5).topSpaceToView(highPriceContent,0).bottomSpaceToView(highPriceContent,0);
        [yuan2 setSingleLineAutoResizeWithMaxWidth:20];
        yuan2.hidden = YES;
        
        
        
        /* 小横杠*/
        UILabel *line1=[[UILabel alloc]init];
        [self addSubview:line1];
        [line1 setText:@"-"];
        [line1 setTextColor:[UIColor blackColor]];
        line1.textAlignment = NSTextAlignmentCenter;
        line1.sd_layout.centerYEqualToView(highPriceContent).rightSpaceToView(highPriceContent,10).heightIs(10);
        [line1 setSingleLineAutoResizeWithMaxWidth:20];
        line1.hidden = YES;
        
        /* 低价输入框*/
        UIView *lowPriceContent1=[[UIView alloc]init];
        [self addSubview:lowPriceContent1];
        lowPriceContent1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        lowPriceContent1.layer.borderWidth = 0.6f;
        lowPriceContent1.sd_layout.topEqualToView(highPriceContent).rightSpaceToView(line1,10).bottomEqualToView(highPriceContent).widthRatioToView(highPriceContent,1.0f);
        lowPriceContent1.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        lowPriceContent1.hidden = YES;
        
        /* 元1*/
        UILabel *yuan1=[[UILabel alloc]init];
        [lowPriceContent1 addSubview:yuan1];
        [yuan1 setText:NSLocalizedString(@"元", nil)];
        [yuan1 setTextColor:[UIColor blackColor]];
        yuan1.sd_layout.rightSpaceToView(lowPriceContent1,5).topSpaceToView(lowPriceContent1,0).bottomSpaceToView(lowPriceContent1,0);
        [yuan1 setSingleLineAutoResizeWithMaxWidth:20];
        yuan1.hidden = YES;
        
        
        /*低价输入框*/
        _lowPrice = [[UITextField alloc]init];
        [lowPriceContent1 addSubview:_lowPrice];
        _lowPrice.textAlignment = NSTextAlignmentCenter;
        _lowPrice.sd_layout.leftSpaceToView(lowPriceContent1,5).topSpaceToView(lowPriceContent1,0).bottomSpaceToView(lowPriceContent1,0).widthRatioToView(lowPriceContent1,4/5.0f);
        _lowPrice.keyboardType=UIKeyboardTypeNumberPad;
        _lowPrice.hidden = YES;
        
        /* 价格范围label*/
        UILabel *priceZone = [[UILabel alloc]init];
        [self addSubview:priceZone];
        [priceZone setText:NSLocalizedString(@"价格范围", nil)];
        [priceZone setTextColor:[UIColor lightGrayColor]];
        priceZone.sd_layout.leftSpaceToView(self,20).centerYEqualToView(lowPriceContent1).autoHeightRatio(0);
        [priceZone setSingleLineAutoResizeWithMaxWidth:100];
        priceZone.hidden = YES;

        
        /* 课时范围输入框*/
        /* 课时 左view*/
//        UIView *classLeftContent =[[UIView alloc]init];
//        [self addSubview:classLeftContent];
//        classLeftContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        classLeftContent.layer.borderWidth = 0.6f;
//        classLeftContent.sd_layout.leftEqualToView(lowPriceContent1).rightEqualToView(lowPriceContent1).topSpaceToView(lowPriceContent1,CGRectGetWidth(self.bounds)/20.0f).heightRatioToView(lowPriceContent1,1.0f);
//        classLeftContent.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
//        /* 课时 左  元*/
//        /* 元3*/
//        UILabel *yuan3=[[UILabel alloc]init];
//        [classLeftContent addSubview:yuan3];
//        [yuan3 setText:@"元"];
//        [yuan3 setTextColor:[UIColor blackColor]];
//        yuan3.sd_layout.rightSpaceToView(classLeftContent,5).topSpaceToView(classLeftContent,0).bottomSpaceToView(classLeftContent,0);
//        [yuan3 setSingleLineAutoResizeWithMaxWidth:20];
        
        /* 课时左输入框*/
//        _class_Low = [[UITextField alloc]init];
//        [classLeftContent addSubview:_class_Low];
//        _class_Low.textAlignment = NSTextAlignmentCenter;
//        _class_Low.sd_layout.leftSpaceToView(classLeftContent,5).topSpaceToView(classLeftContent,0).bottomSpaceToView(classLeftContent,0).widthRatioToView(classLeftContent,4/5.0f);
//        _class_Low.keyboardType =UIKeyboardTypeNumberPad;
        
        
        /* 课时 右view*/
        
//        UIView *classRightContent =[[UIView alloc]init];
//        [self addSubview:classRightContent];
//        classRightContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        classRightContent.layer.borderWidth = 0.6f;
//        classRightContent.sd_layout.leftEqualToView(highPriceContent).rightEqualToView(highPriceContent).topEqualToView(classLeftContent).bottomEqualToView(classLeftContent).centerYEqualToView(classLeftContent);
//        classRightContent.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        
        /* 课时右输入框*/
//        _class_High = [[UITextField alloc]init];
//        [classRightContent addSubview:_class_High];
//        _class_High.textAlignment = NSTextAlignmentCenter;
//        _class_High.sd_layout.leftSpaceToView(classRightContent,5).topSpaceToView(classRightContent,0).bottomSpaceToView(classRightContent,0).widthRatioToView(classRightContent,4/5.0f);
//        _class_High.keyboardType =UIKeyboardTypeNumberPad;
        
        
//        /* 课时 元 右边*/
//        UILabel *yuan4=[[UILabel alloc]init];
//        [classRightContent addSubview:yuan4];
//        [yuan4 setText:@"元"];
//        [yuan4 setTextColor:[UIColor blackColor]];
//        yuan4.sd_layout.rightSpaceToView(classRightContent,5).topSpaceToView(classRightContent,0).bottomSpaceToView(classRightContent,0);
//        [yuan4 setSingleLineAutoResizeWithMaxWidth:20];
        
        
        /* 小横线2*/
        
//        UILabel *line2=[[UILabel alloc]init];
//        [self addSubview:line2];
//        [line2 setText:@"-"];
//        [line2 setTextColor:[UIColor blackColor]];
//        line2.textAlignment = NSTextAlignmentCenter;
//        line2.sd_layout.centerYEqualToView(classRightContent).rightSpaceToView(classRightContent,10).heightIs(10);
//        [line2 setSingleLineAutoResizeWithMaxWidth:20];
        
        /* 课时范围label*/
//        UILabel *classTimeZone = [[UILabel alloc]init];
//        [self addSubview: classTimeZone];
//        
//        [classTimeZone setText:@"课时范围"];
//        [classTimeZone setTextColor:[UIColor lightGrayColor]];
//        classTimeZone.sd_layout.leftEqualToView(priceZone).rightEqualToView(priceZone).centerYEqualToView(classLeftContent).autoHeightRatio(0);
        
        
        
       
        
     
        /* 开课时间 右button*/
        _endTime = [[UIButton alloc]init];
        [_endTime setTitle:NSLocalizedString(@"请选择时间", nil) forState:UIControlStateNormal];
        [_endTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_endTime];
        
        _endTime.sd_layout
        .rightSpaceToView(self,20)
        .widthRatioToView(self,1/3.5f)
        .topSpaceToView(self,20);
        
        /* 小横线3*/
        UILabel *line3=[[UILabel alloc]init];
        [self addSubview:line3];
        [line3 setText:NSLocalizedString(@"至", nil)];
        [line3 setTextColor:[UIColor blackColor]];
        line3.textAlignment = NSTextAlignmentCenter;
        line3.sd_layout
        .centerYEqualToView(_endTime)
        .rightSpaceToView(_endTime,0)
        .heightIs(10);
        [line3 setSingleLineAutoResizeWithMaxWidth:20];
        
        
        /* 开课时间 左button*/
        _startTime = [[UIButton alloc]init];
        [_startTime setTitle:NSLocalizedString(@"请选择时间", nil) forState:UIControlStateNormal];
        [_startTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_startTime];
        _startTime.sd_layout
        .rightSpaceToView(line3,20)
        .widthRatioToView(self,1/3.5f)
        .topEqualToView(_endTime)
        .bottomEqualToView(_endTime);
        
        
        /* 开课时间label*/
     
        UILabel *startTime = [[UILabel alloc]init];
        [self addSubview: startTime];
        
        [startTime setText:NSLocalizedString(@"开课时间", nil)];
        [startTime setTextColor:[UIColor lightGrayColor]];
        startTime.sd_layout.leftEqualToView(priceZone).rightEqualToView(priceZone).centerYEqualToView(_startTime).autoHeightRatio(0);
        
        /* 当前状态部分*/
        /* 当前状态*/
        UILabel *stateNow=[[UILabel alloc]init];
        [self addSubview:stateNow];
        [stateNow setText:NSLocalizedString(@"当前状态", nil)];
        [stateNow setTextColor:[UIColor lightGrayColor]];
        stateNow.sd_layout
        .leftEqualToView(priceZone)
        .rightEqualToView(priceZone)
        .topSpaceToView(startTime,40)
        .autoHeightRatio(0);
        
        /* 开课状态*/
        _class_Begin =[[UIButton alloc]init];
        [self addSubview:_class_Begin];
        [_class_Begin setTitle:NSLocalizedString(@"已开课", nil) forState:UIControlStateNormal];
        [_class_Begin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _class_Begin.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _class_Begin.layer.borderWidth = 0.6f;
        
        _class_Begin.sd_layout
        .leftEqualToView(_startTime)
        .rightEqualToView(_startTime)
        .topEqualToView(stateNow)
        .heightRatioToView(_startTime,1.4);
        _class_Begin.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        

        /* 招生状态*/
        _recuit =[[UIButton alloc]init];
        [self addSubview:_recuit];
        [_recuit setTitle:NSLocalizedString(@"招生中", nil) forState:UIControlStateNormal];
        [_recuit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _recuit.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _recuit.layer.borderWidth = 0.6f;
        
        _recuit.sd_layout
        .leftEqualToView(_endTime)
        .rightEqualToView(_endTime)
        .topEqualToView(stateNow)
        .heightRatioToView(_endTime,1.4);
        _recuit.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
       
        
        /* 重置按钮*/
        _resetButton = [[UIButton alloc]init];
        [self addSubview:_resetButton ];
        [_resetButton setTitle:NSLocalizedString(@"重置", nil) forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetButton setBackgroundColor:[UIColor orangeColor]];
        
        _resetButton.sd_layout
        .leftEqualToView(stateNow)
        .bottomSpaceToView(self,40)
        .widthRatioToView(self,0.42f)
        .heightRatioToView(self,0.2f);
        _resetButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        /* 确定按钮*/
        _finishButton = [[UIButton alloc]init];
        [self addSubview:_finishButton ];
        [_finishButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:[UIColor orangeColor]];
        
        _finishButton.sd_layout.rightEqualToView(_recuit).topEqualToView(_resetButton).widthRatioToView(_resetButton,1.0f).heightRatioToView(_resetButton,1.0f);
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
                
        
    }
    return self;
}


@end
