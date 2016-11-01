//
//  SignUpInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpInfoView : UIView

/* 头像*/
@property(nonatomic,strong) UIImageView *headImage ;

/* 姓名*/
@property(nonatomic,strong) UITextField *userName ;

/* 性别按钮  两个*/
@property(nonatomic,strong) UIButton *boyButton ;
@property(nonatomic,strong) UIButton *girlButton ;

/* 生日*/
@property(nonatomic,strong) UIButton *birthday ;
@property(nonatomic,strong) NSDate *birthDate  ;

/* 年级*/
@property(nonatomic,strong) UIButton *gradeButton ;
@property(nonatomic,strong) NSString *grade ;

/* 完成按钮*/

@property(nonatomic,strong) UIButton  *finishButton ;


/* 上传图片按钮*/
@property(nonatomic,strong) UIButton *uploadPic;


@end
