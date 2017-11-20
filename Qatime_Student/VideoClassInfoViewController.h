//
//  VideoClassInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfoView.h"
#import "LiveClassInfo.h"

#import "VideoClassInfo_InfoViewController.h"
#import "VideoClassInfo_TeacherViewController.h"
#import "VideoClassInfo_ClassListViewController.h"

@interface VideoClassInfoViewController : UIViewController

//子控制器
@property (nonatomic, strong) VideoClassInfo_InfoViewController *infoVC ;
@property (nonatomic, strong) VideoClassInfo_TeacherViewController *teacherVC ;
@property (nonatomic, strong) VideoClassInfo_ClassListViewController *classVC ;

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


- (instancetype)initWithClassID:(NSString *)classID ;

@end
