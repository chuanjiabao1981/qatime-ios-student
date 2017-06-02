//
//  GuestBindingView.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestBindingView : UIScrollView
/**姓名*/
@property (nonatomic, strong) UITextField *nameText ;
/**电话号*/
@property (nonatomic, strong) UITextField *phoneText ;
/**校验码输入框*/
@property (nonatomic, strong) UITextField *chekCodeText ;
/**获取校验码按钮*/
@property (nonatomic, strong) UIButton *getCheckCodeBtn ;
/**密码框*/
@property (nonatomic, strong) UITextField *passwordText ;
/**确认密码框*/
@property (nonatomic, strong) UITextField *passwordConfirmText ;
/**确认协议开关*/
@property (nonatomic, strong) UISwitch *applyProtocolSwitch ;
/**绑定按钮*/
@property (nonatomic, strong) UIButton *finishBtn ;

@end
