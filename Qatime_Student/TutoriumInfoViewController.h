//
//  TutoriumInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/8.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumInfoView.h"

#import "RecommandTeacher.h"
#import "RecommandClasses.h"
#import "ClassesInfo_Time.h"


@interface TutoriumInfoViewController : UIViewController

/* 课程id 用来传参数*/
@property(nonatomic,strong) NSString *classID ;

@property(nonatomic,strong) TutoriumInfoView  *tutoriumInfoView ;


/* 三个页面的不同Model*/
@property(nonatomic,strong) RecommandTeacher *teacherModel;

@property(nonatomic,strong) RecommandClasses *classModel  ;

@property(nonatomic,strong) ClassesInfo_Time *classInfoTimeModel ;


/**
 辅导班编号初始化

 @param classID 辅导班编号
 @return 实例
 */
- (instancetype)initWithClassID:(NSString *)classID;



/**
 辅导班编号/优惠码 初始化

 @param classID 辅导班编号
 @param promotionCode 优惠码
 @return 实例
 */
- (instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode;




@end
