//
//  VideoClassPlayerViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZFPlayer.h"
#import "Teacher.h"
#import "VideoClassInfo.h"
#import "VideoClass.h"
#import "NELivePlayerControl.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"
@interface VideoClassPlayerViewController : UIViewController

/**视频播放器*/
@property (nonatomic, strong) NELivePlayerController <NELivePlayer>* _Nullable videoPlayer ;

/**控制层*/
@property (nonatomic, strong) NELivePlayerControl * _Nullable controlView ;


/**
 初始化方法1

 @param classes 课程列表信息
 @param teacher 教师信息
 @param classInfo 课程详情
 @return 实例
 */
-(instancetype)initWithClasses:(__kindof NSArray <VideoClass *>*_Nullable)classes andTeacher:(Teacher *_Nullable)teacher andVideoClassInfos:(VideoClassInfo *_Nullable)classInfo andURLString:(NSString * _Nullable)URLString andIndexPath:(NSIndexPath * _Nullable)indexPath;


/**
 初始化方法2

 在当前页调用过play接口获取信息
 
 @param teacher 教师信息
 @param classInfo 课程详情
 @param lessonID 视频课的lessonID
 @return 实例
 */
-(instancetype _Nullable)initWithTeacher:(Teacher * _Nonnull)teacher andVideoClassInfos:(VideoClassInfo *_Nonnull)classInfo andVideoLessonID:(NSString *_Nonnull)lessonID ;


@end
