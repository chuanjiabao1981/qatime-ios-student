//
//  InteractionViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESChatroomSegmentedControl.h"
#import "UIView+NTES.h"
#import "NTESPageView.h"
#import "NTESChatroomViewController.h"
#import "NTESChatroomMemberListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+NTES.h"
#import "SVProgressHUD.h"
#import "UIImage+NTESColor.h"
#import "NTESMeetingActionView.h"
#import "UIView+Toast.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingActorsView.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESMeetingRolesManager.h"
#import "NTESDemoService.h"
#import "NTESMeetingNetCallManager.h"
#import "NTESActorSelectView.h"
#import "NIMGlobalMacro.h"
#import "NTESMeetingRolesManager.h"
#import "NTESMeetingWhiteboardViewController.h"
#import <NIMAVChat/NIMAVChat.h>
#import "OneOnOneClass.h"

#import "NTESGLView.h"

#import "InteractionView.h"

#import "Notice.h"
#import "Classes.h"
#import "Teacher.h"
#import "TutoriumList.h"
#import "Members.h"

#import "UUInputFunctionView.h"




@interface InteractionViewController : UIViewController

/**
 聊天房间
 */
@property (nonatomic, copy)   NIMChatroom *chatroom;

/**
 主视图
 */
@property (nonatomic, strong) InteractionView *interactionView ;


/**
 聊天输入框
 */
@property(nonatomic,strong) UUInputFunctionView *inputView ;


//@property (nonatomic, strong) <#NSClass*#> <#Var Name#> ;


/**
 初始化方法

 @param chatroom 传入chatroom对象
 @param notices 通知数组
 @param classInfo 课程信息
 @param teachers 教师组列表
 @param classes 课程列表
 @param members 成员列表
 @return 对象
 */
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom andNotice:(NSArray <Notice *>*)notices andTutorium:(TutoriumListInfo *)classInfo andTeacher:(NSArray <Teacher *>*)teachers andClasses:(NSArray <OneOnOneClass *>*)classes andOnlineMembers:(NSArray <Members *>*)members;

@end