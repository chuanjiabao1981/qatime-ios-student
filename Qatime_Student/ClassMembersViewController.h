//
//  ClassMembersViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassMembersViewController : UIViewController

/**
 课程类型

 - LiveCourse: 直播课
 - InteractionCourse: 一对一
 - ExclusiveCourse: 小班课
 - VideoCourse: 视频课
 */
typedef NS_ENUM(NSUInteger, MemberCourseType) {
    LiveCourse,
    InteractionCourse,
    ExclusiveCourse,
    VideoCourse
};

@property (nonatomic, strong) UITableView *mainView ;

@property (nonatomic, assign) MemberCourseType courseType ;

//-(instancetype)initWithClassID:(NSString *)classID;

//临时修改的课程成员列表初始化方法
-(instancetype)initWithClassID:(NSString *)classID andCourseType:(MemberCourseType)courseType;

@end
