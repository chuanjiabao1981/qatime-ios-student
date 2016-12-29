//
//  SignUpInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpInfoView.h"

#import "UIView+FontSize.h"
@interface SignUpInfoView (){
    
    
}

@end

@implementation SignUpInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        /* 头像*/
        
        _headImage = [[UIImageView alloc]init];
        [self addSubview:_headImage];
        _headImage.layer.borderWidth=2;
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
        [self addSubview:nameText];
        nameText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        nameText.layer.borderWidth = 1;
        
        
        
        /* 姓名输入*/
        _userName = [[UITextField alloc]init];
        [nameText addSubview:_userName];
        _userName.placeholder = @"输入真实姓名更方便老师联系你";
        _userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userName.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        _userName.font = [UIFont systemFontOfSize:18*ScrenScale];
        
        /* 年级选择框*/
        UIView *gradeText = [[UIView alloc]init];
        [self addSubview:gradeText];
        gradeText.layer.borderWidth = 1;
        gradeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /* 年级选择器*/
        _grade = [[UIButton alloc]init];
        [gradeText addSubview:_grade];
        [_grade setTitle:@"选择所在年级" forState:UIControlStateNormal];
        [_grade setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        
        
        /* 完善更多*/
        _moreButton = [[UIButton alloc]init];
        [self addSubview:_moreButton];
        _moreButton.layer.borderColor = [UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.0].CGColor;
        _moreButton.layer.borderWidth = 2;
        [_moreButton setTitle:@"完善更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        
        
        /* 立即进入*/
        _enterButton = [[UIButton alloc]init];
        [self addSubview:_enterButton];
        _enterButton.layer.borderColor = [UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.0].CGColor;
        _enterButton.layer.borderWidth = 2;
        [_enterButton setTitle:@"立即进入" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor colorWithRed:0.79 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
        
        
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
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(head,20)
        .heightIs(self.height_sd*0.07);
        
        _userName.sd_layout
        .leftSpaceToView(nameText,10)
        .rightSpaceToView(nameText,10)
        .topSpaceToView(nameText,10)
        .bottomSpaceToView(nameText,10);
        
        gradeText.sd_layout
        .leftEqualToView(nameText)
        .rightEqualToView(nameText)
        .topSpaceToView(nameText,20)
        .heightRatioToView(nameText,1.0f);
        
        _grade.sd_layout
        .leftSpaceToView(gradeText,10)
        .rightSpaceToView(gradeText,10)
        .topSpaceToView(gradeText,10)
        .bottomSpaceToView(gradeText,10);
        
        
        _moreButton.sd_layout
        .leftEqualToView(gradeText)
        .topSpaceToView(gradeText,20)
        .heightRatioToView(gradeText,0.8f)
        .widthIs(self.width_sd/2.0f-20-10);
        _moreButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        _enterButton.sd_layout
        .rightEqualToView(gradeText)
        .topEqualToView(_moreButton)
        .bottomEqualToView(_moreButton)
        .widthRatioToView(_moreButton,1.0f);
        _enterButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];

                
    }
    return self;
}

@end
