//
//  SignUpInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpInfoView.h"

 
@interface SignUpInfoView (){
    
}

@end

@implementation SignUpInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BACKGROUNDGRAY;
        
        /* 头像*/
        _headImage = [[UIImageView alloc]init];
        [self addSubview:_headImage];
        _headImage.layer.borderWidth=1;
        _headImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _headImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        _headImage.userInteractionEnabled = YES;
        
        /* 头像提示*/
        UILabel *head = [[UILabel alloc]init];
        [self addSubview:head];
        head.textColor = [UIColor lightGrayColor];
        head.font = [UIFont systemFontOfSize:12*ScrenScale];
        head.text = @"点击图片添加头像";
        
        /* 姓名输入框*/
        UIView *nameText = [[UIView alloc]init];
        nameText.backgroundColor = [UIColor whiteColor];
        [self addSubview:nameText];
        nameText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nameText.layer.borderWidth = 1;
        
        
        /* 姓名输入*/
        _userName = [[UITextField alloc]init];
        _userName.backgroundColor = [UIColor whiteColor];
        _userName.font = TEXT_FONTSIZE;
        [nameText addSubview:_userName];
        _userName.placeholder = @"输入真实姓名更方便老师联系你";
        _userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userName.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        /* 年级选择框*/
        UIView *gradeText = [[UIView alloc]init];
        gradeText.backgroundColor = [UIColor whiteColor];
        [self addSubview:gradeText];
        gradeText.layer.borderWidth = 1;
        gradeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /* 年级选择器*/
        _grade = [[UIButton alloc]init];
        [gradeText addSubview:_grade];
        [_grade setTitle:@"选择所在年级" forState:UIControlStateNormal];
        [_grade setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        _grade.titleLabel.font = TEXT_FONTSIZE;
        
        /* 地区选择框*/
        UIView *locationView = [[UIView alloc]init];
        locationView.backgroundColor = [UIColor whiteColor];
        [self addSubview:locationView];
        locationView.layer.borderWidth = 1;
        locationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _chooseLocationButton = [[UIButton alloc]init];
        [locationView addSubview:_chooseLocationButton];
        [_chooseLocationButton setTitle:@"选择地区" forState:UIControlStateNormal];
        [_chooseLocationButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        _chooseLocationButton.titleLabel.font = TEXT_FONTSIZE;
        
        /* 完善更多*/
        _moreButton = [[UIButton alloc]init];
        _moreButton.titleLabel.font = TEXT_FONTSIZE;
        [self addSubview:_moreButton];
        _moreButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _moreButton.layer.borderWidth = 1;
        [_moreButton setTitle:@"完善更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        
        /* 立即进入*/
        _enterButton = [[UIButton alloc]init];
        _enterButton.titleLabel.font = TEXT_FONTSIZE;
        [self addSubview:_enterButton];
        _enterButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _enterButton.layer.borderWidth = 1;
        [_enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
        [_enterButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        
        /* 头像*/
       _headImage.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self,40)
        .widthRatioToView(self,1/5.5f)
        .heightEqualToWidth();
        
        /* 头像提示*/
        head.sd_layout
        .centerXEqualToView(_headImage)
        .topSpaceToView(_headImage,10)
        .autoHeightRatio(0);
        [head setSingleLineAutoResizeWithMaxWidth:500];
    
        /* 姓名框*/
        nameText.sd_layout
        .leftSpaceToView(self,30*ScrenScale)
        .rightSpaceToView(self,30*ScrenScale)
        .topSpaceToView(head,20)
        .heightIs(40*ScrenScale320);
        nameText.sd_cornerRadius = @2;
        
        _userName.sd_layout
        .leftSpaceToView(nameText,10)
        .rightSpaceToView(nameText,10)
        .topSpaceToView(nameText,10)
        .bottomSpaceToView(nameText,10);
        
        /**年级选框*/
        gradeText.sd_layout
        .leftEqualToView(nameText)
        .rightEqualToView(nameText)
        .topSpaceToView(nameText,20*ScrenScale)
        .heightRatioToView(nameText,1.0);
        gradeText.sd_cornerRadius = @2;
        
        _grade.sd_layout
        .leftSpaceToView(gradeText,10)
        .rightSpaceToView(gradeText,10)
        .topSpaceToView(gradeText,10)
        .bottomSpaceToView(gradeText,10);
        
        /**地区选框*/
        locationView .sd_layout
        .leftEqualToView(gradeText)
        .rightEqualToView(gradeText)
        .topSpaceToView(gradeText,20)
        .heightRatioToView(gradeText,1.0);
        locationView.sd_cornerRadius = @2;
        
        _chooseLocationButton.sd_layout
        .leftSpaceToView(locationView,10)
        .rightSpaceToView(locationView,10)
        .topSpaceToView(locationView,10)
        .bottomSpaceToView(locationView,10);

        _moreButton.sd_layout
        .leftEqualToView(locationView)
        .topSpaceToView(locationView,20)
        .heightRatioToView(locationView,1.0)
        .widthIs(self.width_sd/2.0f-15*ScrenScale320-20*ScrenScale);
        _moreButton.sd_cornerRadius = [NSNumber numberWithFloat:1];
        
        _enterButton.sd_layout
        .rightEqualToView(gradeText)
        .topEqualToView(_moreButton)
        .bottomEqualToView(_moreButton)
        .widthRatioToView(_moreButton,1.0f);
        _enterButton.sd_cornerRadius = [NSNumber numberWithFloat:1];

                
    }
    return self;
}

@end
