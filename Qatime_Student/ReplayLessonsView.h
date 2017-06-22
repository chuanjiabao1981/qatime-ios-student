//
//  ReplayLessonsView.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplayLessonsView : UIView

/**课程名*/
@property (nonatomic, strong) UILabel *name ;
/**年级科目*/
@property (nonatomic, strong) UILabel *gradeAndSubject ;
/**教师头像*/
@property (nonatomic, strong) UIImageView *teacherHeaderImage ;
/**教师名字*/
@property (nonatomic, strong) UILabel *teacherName ;
/**教师性别图*/
@property (nonatomic, strong) UIImageView *teacherGenderImage ;
/**视频时长*/
@property (nonatomic, strong) UILabel *duration ;
/**回放次数*/
@property (nonatomic, strong) UILabel *replayTimes ;

@end
