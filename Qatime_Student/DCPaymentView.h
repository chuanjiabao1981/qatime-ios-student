//
//  DCPaymentView.h
//  DCPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completedHandle)(NSString *inputPwd);

@interface DCPaymentView : UIViewController

@property (nonatomic, copy) NSString *titleStr, *detail;
@property (nonatomic, assign) CGFloat amount;
@property(nonatomic,strong) UIImageView *headImage ;

@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);


+(DCPaymentView *)showPayAlertWithTitle:(NSString *)title andDetail:(NSString *)detail andAmount:(CGFloat)amount completeHandle:(completedHandle)handel;

- (void)show;

@end
