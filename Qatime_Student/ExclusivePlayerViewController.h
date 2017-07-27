//
//  ExclusivePlayerViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExclusivePlayerView.h"
#import "ExclusiveChatViewController.h"
#import "ExclusivenNoticeViewController.h"
#import "ExclusivePlayerInfoViewController.h"
#import "ExclusiveMembersViewController.h"

#import "NELivePlayer.h"
#import "NELivePlayerController.h"
#import "LiveClassInfoView.h"
#import "NELivePlayerControl.h"

@interface ExclusivePlayerViewController : UIViewController <NELivePlayer>


@property (nonatomic, strong) ExclusiveChatViewController *chatController;

@property (nonatomic, strong) ExclusivenNoticeViewController *noticeController ;

@property (nonatomic, strong) ExclusivePlayerInfoViewController *infoController ;

@property (nonatomic, strong) ExclusiveMembersViewController *membersController ;

@property (nonatomic, strong) ExclusivePlayerView *mainView ;


/* 播放器 的属性 */
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *decodeType;
@property(nonatomic, strong) NSString *mediaType;

/* 这个遵循协议的属性 才是真正的播放器*/
@property(nonatomic, strong) NELivePlayerController <NELivePlayer> *liveplayerTeacher;
@property(nonatomic, strong) NELivePlayerController <NELivePlayer> *liveplayerBoard;


/* 数据界面层的属性*/

/* 课程id*/
@property(nonatomic,strong) NSString *classID ;

/* 白板拉流地址*/
@property(nonatomic,strong) NSURL *boardPullAddress ;
/* 教师拉流地址*/
@property(nonatomic,strong) NSURL *teacherPullAddress ;


/* 切换屏幕按钮*/
@property(nonatomic,strong) UIButton *switchScreen ;

/* 双屏平铺按钮*/
@property(nonatomic,strong) UIButton *tileScreen ;

/* 弹幕开关*/
@property(nonatomic,strong) UIButton *barrage ;

/**在线人数*/
@property (nonatomic, strong) UILabel *onLineNumber ;

/* 副屏幕开关按钮*/
@property(nonatomic,strong) UIButton *subScreenSwitch ;

/**点击发送，会自动把文本框的内容传递过来*/
@property (nonatomic, strong) void(^sendContent)(NSString *content);

@property(nonatomic, strong)  NELivePlayerControl *mediaControl;


/**
 初始化方法

 @param classID 课程id
 @param chatTeamID chateamid
 @return 1
 */
-(instancetype)initWithClassID:(NSString *)classID andChatTeamID:(NSString *)chatTeamID;

@end
