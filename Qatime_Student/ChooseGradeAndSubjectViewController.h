//
//  ChooseGradeAndSubjectViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGradeAndSubjectView.h"

@interface ChooseGradeAndSubjectViewController : UIViewController

@property (nonatomic, strong) ChooseGradeAndSubjectView *chooseView ;

@property (nonatomic, strong) NSString *selectedFilterGrade;


/**
 首页年级筛选方法

 @param notification 通知内容
 */
- (void)chooseFilterGrade:(NSNotification *)notification;

@end
