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
 初始化方法

 @param classes 课程列表信息
 @param teacher 教师信息
 @param classInfo 课程详情
 @return 实例
 */
-(instancetype)initWithClasses:(__kindof NSArray <VideoClass *>*)classes andTeacher:(Teacher *)teacher andVideoClassInfos:(VideoClassInfo *)classInfo andURLString:(NSString * _Nullable)URLString andIndexPath:(NSIndexPath * _Nullable)indexPath;

@end
