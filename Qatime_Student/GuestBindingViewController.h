//
//  GuestBindingViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GuestBindingView.h"


@interface GuestBindingViewController : UIViewController

@property (nonatomic, strong) GuestBindingView *mainView ;


/**
 绑定手机号成功后,使用该初始化方法

 @param phoneNumber 手机号
 @return 实例
 */
-(instancetype)initWithPhoneNumber:(NSString *)phoneNumber;

 
@end
