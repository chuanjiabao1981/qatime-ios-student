//
//  QuestionInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Qatime_Student-Swift.h"


@interface QuestionInfoViewController : UIViewController

/** 问题详情 */
@property (nonatomic, strong) QuestionInfoView *questionInfoView ;

/** 回答详情 如果有的话 */
@property (nonatomic, strong) QuestionInfoView *answerInfoView ;


@end
