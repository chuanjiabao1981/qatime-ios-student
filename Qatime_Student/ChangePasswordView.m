//
//  ChangePasswordView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChangePasswordView.h"

@interface ChangePasswordView (){
    
    UIView *view1;
    UIView *view2;
    UIView *view3;
    
        
}

@end

@implementation ChangePasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
        
        
    }
    return self;
}

/* 初始化视图*/
- (void)setupViews{
    
    
    view1 = [[UIView alloc]init];
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.borderWidth = 0.6f;
    
    view2 = [[UIView alloc]init];
    view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view2.layer.borderWidth = 0.6f;
    
    view3 = [[UIView alloc]init];
    view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view3.layer.borderWidth = 0.6f;
    
    
    
    _passwordText = [[UITextField alloc]init];
    _passwordText.placeholder = @"输入当前登录密码";
    
    _newsPasswordText = [[UITextField alloc]init];
    _newsPasswordText.placeholder = @"输入新密码";
    
    
    _comparePasswordText = [[UITextField alloc]init];
    _comparePasswordText.placeholder = @"确认新密码";
    
    
    
    _forgetPassword = [[UIButton alloc]init];
    [_forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPassword setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    
    _finishButton = [[UIButton alloc]init];
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    _finishButton.backgroundColor = [UIColor orangeColor];
    
    
    _passwordImage = [[UIImageView alloc]init];
    _comparePasswordImage = [[UIImageView alloc]init];
    
    
    
    [self autoLayoutViews];
    
}

/* 布局*/
- (void)autoLayoutViews{
    
    [self sd_addSubviews:@[view1,view2,view3,_forgetPassword,_finishButton]];
    
    [view1 addSubview:_passwordText];
    [view2 sd_addSubviews:@[_newsPasswordText,_passwordImage]];
    [view3 sd_addSubviews:@[_comparePasswordImage,_comparePasswordText]];
    
    
    view1.sd_layout
    .leftSpaceToView(self,20)
    .rightSpaceToView(self,20)
    .topSpaceToView(self,20)
    .heightRatioToView(self ,0.065f);
    
    
    _passwordText.sd_layout
    .leftSpaceToView(view1,10)
    .rightSpaceToView(view1,10)
    .topSpaceToView(view1,10)
    .bottomSpaceToView(view1,10);
    
    
    _forgetPassword.sd_layout
    .topSpaceToView(view1,10)
    .rightEqualToView(view1)
    .heightIs(20)
    .widthIs(100);
    
    view2.sd_layout
    .leftEqualToView(view1)
    .rightEqualToView(view1)
    .topSpaceToView(_forgetPassword,10)
    .heightRatioToView(view1,1.0f);
    
    _passwordImage.sd_layout
    .topSpaceToView(view2,10)
    .bottomSpaceToView(view2,10)
    .rightSpaceToView(view2,10)
    .widthEqualToHeight();
    
    
    _newsPasswordText.sd_layout
    .leftSpaceToView(view2,10)
    .rightSpaceToView(_passwordImage,20)
    .topSpaceToView(view2,10)
    .bottomSpaceToView(view2,10);
    
    
    view3.sd_layout
    .leftEqualToView(view2)
    .rightEqualToView(view2)
    .topSpaceToView(view2,20)
    .heightRatioToView(view2,1.0f);
    
    _comparePasswordImage.sd_layout
    .topSpaceToView(view3,10)
    .bottomSpaceToView(view3,10)
    .rightSpaceToView(view3,10)
    .widthEqualToHeight();
    
    _comparePasswordText.sd_layout
    .leftSpaceToView(view3,10)
    .rightSpaceToView(_comparePasswordImage,20)
    .topSpaceToView(view3,10)
    .bottomSpaceToView(view3,10);
    
    
    _finishButton.sd_layout
    .leftEqualToView(view3)
    .rightEqualToView(view3)
    .topSpaceToView(view3,20)
    .heightRatioToView(view3,1.0f);
    
    
    
}



@end
