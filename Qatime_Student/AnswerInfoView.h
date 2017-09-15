//
//  AnswerInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answers.h"

@interface AnswerInfoView : UIView

@property (nonatomic, strong) UILabel *created_at ;

@property (nonatomic, strong) UILabel *answer ;

@property (nonatomic, strong) Answers *model ;

@end
