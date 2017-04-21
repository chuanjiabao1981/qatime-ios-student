//
//  ChooseGradeAndSubjectDelegate.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseGradeAndSubjectDelegate <NSObject>


/**
 选择年级

 @param grade 年级字段
 */
- (void)chooseGrade:(NSString *)grade ;

@end
