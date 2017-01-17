//
//  SetNewPasswordViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SetPayPasswordViewController.h"

@interface SetNewPasswordViewController : SetPayPasswordViewController

@property(nonatomic,strong) UIButton *nextButton ;

@property(nonatomic,strong) UIButton *findPassword ;

-(instancetype)initWithType:(SetPayPassordType)type andPassword:(NSString *)password;

@end
