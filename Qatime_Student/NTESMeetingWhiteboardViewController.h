//
//  NTESMeetingWhiteboardViewController.h
//  NIMEducationDemo
//
//  Created by fenric on 16/10/25.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+NTES.h"
#import "NTESMeetingRolesManager.h"
#import "NTESColorSelectView.h"
#import "NTESMeetingRTSManager.h"
#import "UIView+Toast.h"
#import "NTESWhiteboardCommand.h"
#import "NTESWhiteboardCmdHandler.h"
#import "NTESWhiteboardLines.h"
#import "NTESWhiteboardDrawView.h"

#import "UIAlertView+NTESBlock.h"


#import "UIImageView+WebCache.h"


@interface NTESMeetingWhiteboardViewController : UIViewController

@property (nonatomic, strong) NTESWhiteboardDrawView *drawView;

@property (nonatomic, strong) UIView *controlPannel;

@property (nonatomic, strong) UIButton *clearAllButton;

@property (nonatomic, strong) UIButton *cancelLineButton;

@property (nonatomic, strong) UIButton *colorSelectButton;

@property (nonatomic, strong) UIButton *openDocumentButton;

@property (nonatomic, strong) NTESColorSelectView *colorSelectView;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) NTESWhiteboardCmdHandler *cmdHander;



@property (nonatomic, strong) NTESWhiteboardLines *lines;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSString *myUid;

@property (nonatomic, strong) UIView *laserView;

@property (nonatomic, strong) UIImageView *docView;

@property (nonatomic, strong) NIMDocTranscodingInfo *docInfo;

@property (nonatomic, strong) UIButton *previousButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UILabel *pageNumLabel;

@property (nonatomic, strong) UILabel *imgloadLabel;

@property (nonatomic, strong) UIButton *closeDocButton;

@property (nonatomic) int currentPage;

@property (nonatomic, strong) NSMutableDictionary *docInfoDic;

//@property (nonatomic, assign) BOOL isManager ;

@property (nonatomic, strong) NSString *name ;

//@property (nonatomic, strong) NSString *managerUid ;

@property (nonatomic) int myDrawColorRGB ;

@property (nonatomic, assign) BOOL isJoined ;

/** 彻底遮挡整块白板  */
@property (nonatomic, strong) UIView *maskView ;

- (instancetype)initWithChatroom:(NIMChatroom *)room;

-(instancetype)initWithClassID:(NSString *)classID;


- (void)checkPermission;

@end
