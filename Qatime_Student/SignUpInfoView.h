//
//  SignUpInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@interface SignUpInfoView : UIView

/* 头像*/
@property(nonatomic,strong) UIImageView *headImage ;

/* 姓名*/
@property(nonatomic,strong) UITextField *userName ;

/**
 选择年级
 */
@property(nonatomic,strong) UIButton *grade ;

/* 完成按钮*/
@property(nonatomic,strong) UIButton *enterButton ;
@property(nonatomic,strong) UIButton *moreButton ;

/**
 选择地区按钮
 */
@property (nonatomic, strong) UIButton *chooseLocationButton ;

@end
