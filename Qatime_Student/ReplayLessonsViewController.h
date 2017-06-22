//
//  ReplayLessonsViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NELivePlayerController.h"
#import "NELivePlayerControl.h"
#import "ReplayLesson.h"
@interface ReplayLessonsViewController : UIViewController

/**视频播放器*/
@property (nonatomic, strong) NELivePlayerController <NELivePlayer>* _Nullable videoPlayer ;

/**控制层*/
@property (nonatomic, strong) NELivePlayerControl * _Nullable controlView ;

/**主视图*/
@property (nonatomic, strong) UIView * _Nonnull mainView ;


-(instancetype _Nullable)initWithLesson:(ReplayLesson *_Nullable)replayLesson;


@end
