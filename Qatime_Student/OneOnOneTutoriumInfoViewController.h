//
//  OneOnOneTutoriumInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneOnOneTutorimInfoView.h"

@interface OneOnOneTutoriumInfoViewController : UIViewController


/* 课程id 用来传参数*/
@property(nonatomic,strong) NSString *classID ;

/**主页面*/
@property (nonatomic, strong) OneOnOneTutorimInfoView *myView ;


/* 三个页面的不同Model*/
//@property(nonatomic,strong) RecommandTeacher *teacherModel;
//
//@property(nonatomic,strong) RecommandClasses *classModel  ;
//
//@property(nonatomic,strong) ClassesInfo_Time *classInfoTimeModel ;


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
