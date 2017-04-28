//
//  AuthenCode.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenCode : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

@end
