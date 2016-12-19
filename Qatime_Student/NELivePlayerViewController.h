//
//  NELivePlayerViewController.h
//  NELivePlayerDemo
//
//  Created by NetEase on 15-10-10.
//  Copyright (c) 2015年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NELivePlayer.h"
#import "NELivePlayerController.h"

#import "RDVTabBarController.h"

#import "UIViewController+ZFPlayer.h"
#import "VideoInfoView.h"
#import "InfoHeaderView.h"
#import "MembersListView.h"




@class NELivePlayerControl;
@interface NELivePlayerViewController : UIViewController <NELivePlayer>

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

/* 视频信息页面*/
@property(nonatomic,strong) VideoInfoView *videoInfoView ;

@property(nonatomic,strong) InfoHeaderView *infoHeaderView ;
/* 在线成员列表页*/
@property(nonatomic,strong) MembersListView *memberListView;


/* 切换屏幕按钮*/
@property(nonatomic,strong) UIButton *switchScreen ;

/* 双屏平铺按钮*/
@property(nonatomic,strong) UIButton *tileScreen ;

/* 弹幕开关*/
@property(nonatomic,strong) UIButton *barrage ;


/**
 *  点击发送，会自动把文本框的内容传递过来
 */
@property (nonatomic, strong) void(^sendContent)(NSString *content);


/**
 数据界面信息 初始化方法

 @param classID 课程id
 @return 返回初始化对象
 */

-(instancetype)initWithClassID:(NSString *)classID;


/**
 传入课程id和播放地址的初始化器

 @param classID 课程id
 @param boardPullAddress 白板拉流地址
 @param teacherPullAddress 教师拉流地址
 @return 播放器对象
 */
//-(instancetype)initWithClassID:(NSString *)classID andBoardPullAddress:(NSURL *)boardPullAddress andTeacherPullAddress:(NSURL *)teacherPullAddress;



/* 播放器的初始化方法*/

- (id)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm completion:(void(^)())completion;

@property(nonatomic, strong)  NELivePlayerControl *mediaControl;

@end

