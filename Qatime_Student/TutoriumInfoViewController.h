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

#import "BuyBar.h"
#import "NavigationBar.h"

#import "TutoriumInfo_InfoViewController.h"
#import "TutoriumInfo_TeacherViewController.h"
#import "TutoriumInfo_ClassListViewController.h"

@interface TutoriumInfoViewController : UIViewController

/* 课程id 用来传参数*/
@property(nonatomic,strong) NSString *classID ;

@property (nonatomic, strong) NSString *chatTeamID ;

@property(nonatomic,strong) TutoriumInfoView  *tutoriumInfoView ;

@property (nonatomic, strong) NavigationBar *navigationBar;


/* 三个页面的不同Model*/
@property(nonatomic,strong) RecommandTeacher *teacherModel;

@property(nonatomic,strong) RecommandClasses *classModel  ;

@property(nonatomic,strong) ClassesInfo_Time *classInfoTimeModel ;

//子类用的属性
/**课程特色数组*/
@property (nonatomic, strong) NSMutableArray *classFeaturesArray;

/* 保存课程列表的array*/
@property (nonatomic, strong) NSMutableArray *classListArray;

/* 标签图的config*/
@property (nonatomic, strong) TTGTextTagConfig *config;

 /* 购买bar*/
@property (nonatomic, strong) BuyBar *buyBar;

/** 是否购买该课程 */
@property (nonatomic, assign) BOOL isBought;

/** 优惠吗 */
@property (nonatomic, strong) NSString *promotionCode ;

/**学习流程所需的数据*/
//@property (nonatomic, strong) NSArray *workFlowArr;


/** 子控制器 */
@property (nonatomic, strong) TutoriumInfo_InfoViewController *infoVC ;
@property (nonatomic, strong) TutoriumInfo_TeacherViewController *teacherVC ;
@property (nonatomic, strong) TutoriumInfo_ClassListViewController *classVC ;


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

/**
 判断课程状态是否购买 公开方法,给子类重写

 @param dic 数据
 */
- (void)switchClassData:(NSDictionary *)dic;

@end
