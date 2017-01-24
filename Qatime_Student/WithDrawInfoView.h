//
//  WithDrawInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawInfoView : UIView

/* 账号*/
@property(nonatomic,strong) UITextField *accountText ;

/* 姓名*/
@property(nonatomic,strong) UITextField *nameText ;

/* 验证码*/
//@property(nonatomic,strong) UITextField *keyCodeText ;

/* 获取验证码*/
//@property(nonatomic,strong) UIButton *getKeyCodeButton ;


/* 申请按钮*/
@property(nonatomic,strong) UIButton *applyButton ;


@end
