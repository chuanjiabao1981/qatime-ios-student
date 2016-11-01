//
//  SignUpInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpInfoView.h"

@interface SignUpInfoView (){
    /* 底层视图*/
    UIView *_contentView;
    
    /* 头像label*/
    UILabel *headImage;
    
    /* 姓名label*/
    UILabel *userName;
    
    /* 性别label*/
    UILabel *gender;
    UILabel *boy;
    UILabel *girl;
    
    /* 生日label*/
    UILabel *birthday;
    
    /* 年级 label*/
    
    UILabel *grade;
    
    
    
    
    
    
}

@end

@implementation SignUpInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        /* 底层视图布局*/
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
        _contentView.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,20).topSpaceToView(self,20).heightRatioToView(self,0.5);
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.borderWidth = 0.6f;
        _contentView.backgroundColor = [UIColor whiteColor];
        
        
        /* 头像*/
        
        _headImage = [[UIImageView alloc]init];
        [_contentView addSubview:_headImage];
        _headImage.sd_layout.topSpaceToView(_contentView,20).centerXEqualToView(_contentView).widthRatioToView(_contentView,0.15).heightEqualToWidth();
        _headImage.layer.borderWidth=1;
        _headImage.layer.borderColor = [UIColor grayColor].CGColor;
        _headImage.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        /* 头像label*/
        headImage = [[UILabel alloc]init];
        [headImage setText:@"头像"];
        headImage.textColor = [UIColor blackColor];
        
        [_contentView addSubview:headImage ];
        
        headImage.sd_layout.centerYEqualToView(_headImage).heightIs(30).widthIs(80).leftSpaceToView(_contentView,(float)CGRectGetWidth(self.frame)/10.0);
        
        /* 上传头像按钮*/
        _uploadPic = [[UIButton alloc]init];
        [_contentView addSubview:_uploadPic];
        [_uploadPic setTitle:@"上传照片" forState:UIControlStateNormal];
        [_uploadPic setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _uploadPic.sd_layout.centerYEqualToView(_headImage).heightIs(30).widthIs(80).leftSpaceToView(_headImage,(float)CGRectGetWidth(self.frame)/10.0);
        
        /* 分割线1*/
        UIView *line1=[[UIView alloc]init];
        [_contentView addSubview:line1];
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.sd_layout.leftSpaceToView(_contentView,10).rightSpaceToView(_contentView,10).topSpaceToView(_headImage,20).heightIs(0.4f);
        
        
        /* 姓名label*/
        userName = [[UILabel alloc]init];
        [_contentView addSubview:userName];
        userName.text = @"姓名";
        userName.textColor = [UIColor blackColor];
        userName.sd_layout.leftEqualToView(headImage).topSpaceToView(line1,10).heightRatioToView(headImage,1.0f).heightRatioToView(headImage,1.0f);
        /* 星型label1*/
        UILabel *star1=[[UILabel alloc]init];
        [_contentView addSubview:star1];
        [star1 setText:@"*"];
        [star1 setTextColor:[UIColor redColor]];
        star1.textAlignment = NSTextAlignmentRight;
        star1.sd_layout.rightSpaceToView(userName,0).topEqualToView(userName).bottomEqualToView(userName).widthIs(10);
        
        /* 姓名输入框*/
        _userName = [[UITextField alloc]init];
        [_contentView addSubview:_userName];
        _userName.placeholder = @"输入真实姓名更方便老师联系你";
        _userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _userName.layer.borderWidth=0.6;
        [_userName setFont:[UIFont systemFontOfSize:14]];
        _userName.sd_layout.leftSpaceToView(userName,5).widthRatioToView(_contentView,0.7f).bottomEqualToView(userName).topEqualToView(userName);
        userName.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        
        /* 分割线2*/
        UIView *line2=[[UIView alloc]init];
        [_contentView addSubview:line2];
        line2.backgroundColor = [UIColor lightGrayColor];
        line2.sd_layout.leftSpaceToView(_contentView,10).rightSpaceToView(_contentView,10).topSpaceToView(_userName,10).heightIs(0.4f);
        
        
        /* 性别label*/
        gender = [[UILabel alloc]init];
        [_contentView addSubview:gender];
        gender.text=@"性别";
        gender.textColor = [UIColor blackColor];
        gender.sd_layout.leftEqualToView(headImage).topSpaceToView(line2,10).heightRatioToView(headImage,1.0f).heightRatioToView(headImage,1.0f);
        
        /* "男生"选项*/
        _boyButton = [[UIButton alloc]init];
        [_contentView addSubview:_boyButton];
        _boyButton.layer.borderWidth = 0.6f;
        _boyButton.layer.borderColor = [UIColor grayColor].CGColor;
        _boyButton.sd_layout.centerYEqualToView(gender).leftSpaceToView(gender,5).heightRatioToView(gender,0.6f).widthEqualToHeight();
        _boyButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5f];
        
        /* 男生 label*/
        boy = [[UILabel alloc]init];
        [_contentView addSubview: boy];
        boy.text = @"我是男神";
        boy.textColor = [UIColor blackColor];
        boy.sd_layout.leftSpaceToView(_boyButton,5).heightRatioToView(gender,1.0f).widthIs(80).centerYEqualToView(gender);
        
        /* "女生"选项*/
        
        _girlButton = [[UIButton alloc]init];
        [_contentView addSubview:_girlButton];
        _girlButton.layer.borderWidth = 0.6f;
        _girlButton.layer.borderColor = [UIColor grayColor].CGColor;
        _girlButton.sd_layout.centerYEqualToView(gender).leftSpaceToView(boy,10).heightRatioToView(gender,0.6f).widthEqualToHeight();
        _girlButton.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5f];
        
        /* “女生”label*/
        girl = [[UILabel alloc]init];
        [_contentView addSubview: girl];
        girl.text = @"我是女神";
        girl.textColor = [UIColor blackColor];
        girl.sd_layout.leftSpaceToView(_girlButton,5).heightRatioToView(gender,1.0f).widthIs(80).centerYEqualToView(gender);
        
        /* 分割线3*/
        UIView *line3=[[UIView alloc]init];
        [_contentView addSubview:line3];
        line3.backgroundColor = [UIColor lightGrayColor];
        line3.sd_layout.leftSpaceToView(_contentView,10).rightSpaceToView(_contentView,10).topSpaceToView(gender,10).heightIs(0.4f);

        
        /* 生日label*/
        birthday = [[UILabel alloc]init];
        birthday.text = @"生日";
        birthday.textColor=[UIColor blackColor];
        [_contentView addSubview: birthday];
        birthday.sd_layout.topSpaceToView(line3,10).leftEqualToView(gender).rightEqualToView(gender).heightRatioToView(gender,1.0f);
        
        /* 生日选择器*/

        _birthday = [[UIButton alloc]init];
        [_contentView addSubview: _birthday];
        [_birthday setTitle:@"请选择日期" forState:UIControlStateNormal];
        _birthday.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [_birthday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _birthday.sd_layout.centerYEqualToView(birthday).leftSpaceToView(birthday,5).heightRatioToView(gender,0.6f).widthRatioToView(_contentView,0.5f);
        
        
        /* 分割线4*/
        UIView *line4=[[UIView alloc]init];
        [_contentView addSubview:line4];
        line4.backgroundColor = [UIColor lightGrayColor];
        line4.sd_layout.leftSpaceToView(_contentView,10).rightSpaceToView(_contentView,10).topSpaceToView(birthday,10).heightIs(0.4f);
        
        /* 年级 label*/
        grade = [[UILabel alloc]init];
        [_contentView addSubview:grade];
        [grade setText:@"年级"];
        grade.textColor = [UIColor blackColor];
        grade.sd_layout.topSpaceToView(line4,10).leftEqualToView(birthday).rightEqualToView(birthday).heightRatioToView(birthday,1.0f);
        
        
        /* 星星label2*/
        
        UILabel *star2=[[UILabel alloc]init];
        [_contentView addSubview:star2];
        [star2 setText:@"*"];
        [star2 setTextColor:[UIColor redColor]];
        star2.textAlignment = NSTextAlignmentRight;
        star2.sd_layout.rightSpaceToView(grade,0).topEqualToView(grade).bottomEqualToView(grade).widthIs(10);
        
        /* 年级选择器*/
        _gradeButton = [[UIButton alloc]init];
        [_contentView addSubview:_gradeButton];
        _gradeButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_gradeButton setTitle:@"请选择年级" forState:UIControlStateNormal];
        [_gradeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _gradeButton.sd_layout.leftEqualToView(_birthday).rightEqualToView(_birthday).heightRatioToView (_birthday,1).widthRatioToView(_birthday,1).centerYEqualToView(grade);
        
        
        
        /* 完成按钮*/

        _finishButton = [[UIButton alloc]init];
        [self addSubview: _finishButton];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:[UIColor colorWithRed:231/255.0f green:151/255.0f blue:105/255.0f alpha:1.0f]];
        _finishButton .sd_layout.leftEqualToView(_contentView).rightEqualToView(_contentView).topSpaceToView(_contentView,20).heightRatioToView(self,0.08f);
        _finishButton.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        [_finishButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        
        
        
        
        
        
        
    }
    return self;
}

@end
