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

#import "NTESMeetingNetCallManager.h"
#import "NTESActorSelectView.h"
#import "NIMGlobalMacro.h"
#import "NTESMeetingRolesManager.h"
#import "NTESMeetingWhiteboardViewController.h"
#import <NIMAVChat/NIMAVChat.h>
#import "OneOnOneClass.h"

#import "NTESGLView.h"

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
 初始化方法3

 @param chatroom 聊天室对象
 @return 对象
 */
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom andClassID:(NSString *)classID andChatTeamID:(NSString *)chatTeamID andLessonName:(NSString *)lessonName;


@end
