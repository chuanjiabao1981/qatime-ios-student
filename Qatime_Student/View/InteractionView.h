//
//  InteractionView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionInfoHeadView.h"
#import "FJFloatingView.h"
#import "HMSegmentedControl.h"
#import "InteractionControl.h"
#import "NTESWhiteboardDrawView.h"
#import "IJKFloatingView.h"
#import "NTESMeetingActorsView.h"

#import "UIView+PlaceholderImage.h"

@protocol InteractionOverlayDelegate <NSObject>

- (void)controlOnOverlay:(UIControl *)sender;

@end


@interface InteractionView : UIView

/**
 互动视频播放页
 */
@property (nonatomic, strong) NTESMeetingActorsView *teacherCameraView ;

/**
 摄像头的 覆盖控制层
 */
@property (nonatomic, strong) UIControl *cameraOverlay ;

/**
 控制栏
 */
@property (nonatomic, strong) InteractionControl *topControl ;

/**
 学生摄像头
 */
//@property (nonatomic, strong) IJKFloatingView *studentCameraView ;



/**
 segment控制器
 */
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;

/**
 大滑动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView ;

/**
 白板
 */
@property (nonatomic, strong) UIView *whiteBoardView ;

/**
 改变画笔颜色按钮
 */
@property (nonatomic, strong) UIButton *changeColorButton ;

/**
 撤销按钮
 */
@property (nonatomic, strong) UIButton *backSpaceButon ;

/**
 聊天视图
 */
@property (nonatomic, strong) UIView *chatView;

/**
 聊天内容图
 */
@property (nonatomic, strong) UITableView *chatTableView ;

/**
 公告列表图
 */
@property (nonatomic, strong) UITableView *noticeTableView ;

/**
 课程列表图
 */
@property (nonatomic, strong) UITableView *classListTableView ;

/**
 课程详情图
 */
@property (nonatomic, strong) InteractionInfoHeadView *classInfoView ;

/**
 成员视图
 */
@property (nonatomic, strong) UITableView *membersTableView ;


@property (nonatomic, weak) id <InteractionOverlayDelegate> delegate ;


@end
