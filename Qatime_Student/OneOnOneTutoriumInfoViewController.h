//
//  OneOnOneTutoriumInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneOnOneTutorimInfoView.h"
#import "InteractiveInfo_InfoViewController.h"
#import "InteractiveInfo_TeacherViewController.h"
#import "InteractiveInfo_ClassListViewController.h"

@interface OneOnOneTutoriumInfoViewController : UIViewController

/* 课程id 用来传参数*/
@property(nonatomic,strong) NSString *classID ;

/**主页面*/
@property (nonatomic, strong) OneOnOneTutorimInfoView *myView ;


/** 是否购买该课程 */
@property (nonatomic, assign) BOOL isBought;

/** 课程是否已经结束 */
@property (nonatomic, assign) BOOL isFinished ;

/** 是否加入了试听 */
@property (nonatomic, assign) BOOL onlyTaste ;

/** 试听是否结束 */
@property (nonatomic, assign) BOOL tasteOver ;

/** 是否免费课 */
@property (nonatomic, assign) BOOL freeClass ;

//子控制器
@property (nonatomic, strong) InteractiveInfo_InfoViewController *infoVC ;
@property (nonatomic, strong) InteractiveInfo_TeacherViewController *teacherVC ;
@property (nonatomic, strong) InteractiveInfo_ClassListViewController *classVC ;

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
