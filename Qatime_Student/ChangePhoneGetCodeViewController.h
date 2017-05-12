//
//  ChangePhoneGetCodeViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangePhoneGetCodeView.h"

typedef enum : NSUInteger {
    ChangeEmail,
    ChangePhone,
} VerifyType;

@interface ChangePhoneGetCodeViewController : UIViewController

@property(nonatomic,strong) ChangePhoneGetCodeView *getCodeView ;

-(instancetype)initWithVerifyType:(VerifyType)verifyType;


@end
