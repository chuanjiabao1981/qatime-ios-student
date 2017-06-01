//
//  UIViewController+Token.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController_Token.h"

@interface UIViewController (Token)

@property (nonatomic, strong) NSString *token ;

@property (nonatomic, strong) NSString *teacherID ;


/**提出token*/
-(NSString *)getToken;

/**提出techerID*/
-(NSString *)getTeacherID;

@end
