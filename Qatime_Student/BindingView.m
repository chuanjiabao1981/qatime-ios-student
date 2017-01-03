//
//  BindingView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "BindingView.h"

@interface BindingView (){
    
    
    UIButton *_userPolicy;
    
    BOOL selectedPolicy;
}

@end

@implementation BindingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        /* 年级选择器*/
        _grade = [[UIButton alloc]init];
        [self addSubview:_grade];
        //        _grade.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
        [_grade setTitle:@"选择所在年级" forState:UIControlStateNormal];
        _grade.titleLabel.textAlignment = NSTextAlignmentLeft;
        _grade.titleLabel.font = [UIFont systemFontOfSize:18*ScrenScale];
        [_grade setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        
        _grade.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _grade.layer.borderWidth = 0.6;
        
        [self.nextStepButton setTitle:@"绑定" forState:UIControlStateNormal];
        [self.nextStepButton setTitleColor:[UIColor colorWithRed:0.79 green:0.00 blue:0.00 alpha:1.00] forState:UIControlStateNormal];
        self.nextStepButton.backgroundColor = [UIColor whiteColor];
        self.nextStepButton.layer.borderColor = [UIColor colorWithRed:0.79 green:0.00 blue:0.00 alpha:1.00].CGColor;
        self.nextStepButton.layer.borderWidth = 1;
        
        
        
        /* 布局和布局修改*/
        
        self.phoneNumber.sd_layout
        .leftSpaceToView(self,20)
        .rightSpaceToView(self,20)
        .topSpaceToView(self,20)
        .heightRatioToView(self,0.1);
        
        self.checkCode.sd_layout
        .topSpaceToView(self.phoneNumber,15)
        .leftSpaceToView(self,20)
        .widthIs(self.width_sd/2-40)
        .heightRatioToView(self.phoneNumber,1.0f);
        
        self.getCheckCodeButton.sd_layout
        .topEqualToView(self.checkCode)
        .leftSpaceToView(self.checkCode,0)
        .rightEqualToView(self.phoneNumber)
        .heightRatioToView(self.checkCode,1.0);

        self.userPassword.sd_layout
        .topSpaceToView(self.checkCode,20)
        .leftEqualToView(self.checkCode)
        .rightEqualToView( self.getCheckCodeButton)
        .heightRatioToView(self.checkCode,1.0f);
        
        self.userPasswordCompare.sd_layout
        .topSpaceToView(self.userPassword,20)
        .leftEqualToView(self.userPassword)
        .rightEqualToView( self.userPassword)
        .heightRatioToView(self.userPassword,10.f);
        
        
        _grade.sd_layout
        .leftEqualToView(self.userPasswordCompare)
        .rightEqualToView(self.userPasswordCompare)
        .topSpaceToView(self.userPasswordCompare,20)
        .heightRatioToView(self.userPasswordCompare,1.0f);
        _grade.sd_cornerRadius = [NSNumber numberWithFloat:M_PI];
        
        [self.chosenButton sd_clearAutoLayoutSettings];
        
        self.chosenButton.sd_layout
        .topSpaceToView(self.grade,20)
        .leftEqualToView(self.grade)
        .widthIs(20)
        .heightIs(20);
        
         [self.accessLabel sd_clearAutoLayoutSettings];
        self.accessLabel.sd_layout
        .leftSpaceToView(self.chosenButton,10)
        .topEqualToView(self.chosenButton)
        .bottomEqualToView(self.chosenButton);
        [self.accessLabel setSingleLineAutoResizeWithMaxWidth:200];
        
         [self.userPolicy sd_clearAutoLayoutSettings];
        self.userPolicy.sd_resetLayout
        .leftSpaceToView(self.accessLabel,0)
        .topEqualToView(self.accessLabel)
        .bottomEqualToView(self.accessLabel)
        .widthIs(220);
        
        [self.nextStepButton sd_clearAutoLayoutSettings];
        self.nextStepButton.sd_layout
        .leftEqualToView(self.grade)
        .rightEqualToView(self.grade)
        .topSpaceToView(self.chosenButton,20)
        .heightRatioToView(self.grade,1.0f);
        

    }
    return self;
}

@end
