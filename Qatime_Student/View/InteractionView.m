//
//  InteractionView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionView.h"

@implementation InteractionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //教师摄像头布局
        [self addSubview:self.teacherCameraView];
        self.teacherCameraView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .autoHeightRatio(9/16.0);
        
        //控制层布局
        [self.teacherCameraView addSubview:self.cameraOverlay];
        self.cameraOverlay.sd_layout
        .leftSpaceToView(self.teacherCameraView, 0)
        .topSpaceToView(self.teacherCameraView, 0)
        .bottomSpaceToView(self.teacherCameraView, 0)
        .rightSpaceToView(self.teacherCameraView, 0);
        
        
        //顶部控制栏布局
        [self.cameraOverlay addSubview:self.topControl];
        self.topControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topEqualToView(self)
        .heightIs(44);
//
//        //学生摄像头布局
//        [self addSubview:self.studentCameraView];
//        self.studentCameraView.sd_layout
//        .leftEqualToView(self)
//        .topEqualToView(self)
//        .widthRatioToView(self.teacherCameraView, 0.5)
//        .autoHeightRatio(9/16.0);
        
        //控制器布局
        [self addSubview:self.segmentControl];
        self.segmentControl.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(self.teacherCameraView, 0)
        .heightIs(40*ScrenScale);
        
        //滑动视图布局
        [self addSubview:self.scrollView];
        self.scrollView.sd_layout
        .topSpaceToView(self.segmentControl, 1)
        .leftEqualToView(self.segmentControl)
        .rightEqualToView(self.segmentControl)
        .bottomSpaceToView(self, 0);
        
        //白板
        [self.scrollView addSubview:self.whiteBoardView];
        self.whiteBoardView.sd_layout
        .leftSpaceToView(self.scrollView, 0)
        .topSpaceToView(self.scrollView, 0)
        .widthIs(self.width_sd)
        .bottomSpaceToView(self.scrollView, 0);
        
        //聊天
        [self.scrollView addSubview:self.chatView];
        self.chatView.sd_layout
        .leftSpaceToView(self.whiteBoardView, 0)
        .topEqualToView(self.whiteBoardView)
        .bottomEqualToView(self.whiteBoardView)
        .widthIs(self.width_sd);
        
        //聊天内容
        [self.chatView addSubview:self.chatTableView];
        _chatTableView.sd_layout
        .topSpaceToView(self.chatView, 0)
        .leftSpaceToView(self.chatView, 0)
        .rightSpaceToView(self.chatView, 0)
        .bottomSpaceToView(self.chatView, TabBar_Height);
        
        //公告
        [self.scrollView addSubview:self.noticeTableView];
        self.noticeTableView.sd_layout
        .leftSpaceToView(self.chatView, 0)
        .topEqualToView(self.chatView)
        .bottomEqualToView(self.chatView)
        .widthIs(self.width_sd);
        
        //课程列表和课程详情
        [self.scrollView addSubview:self.classListTableView];
        self.classListTableView.sd_layout
        .leftSpaceToView(self.noticeTableView, 0)
        .topEqualToView(self.noticeTableView)
        .bottomEqualToView(self.noticeTableView)
        .widthIs(self.width_sd);

        //成员
        [self.scrollView addSubview:self.membersTableView];
        self.membersTableView.sd_layout
        .leftSpaceToView(self.classListTableView, 0)
        .topEqualToView(self.classListTableView)
        .bottomEqualToView(self.classListTableView)
        .widthIs(self.width_sd);
        
        //scrollview横向自适应
        [self.scrollView updateLayout];
        self.scrollView.contentSize = CGSizeMake(self.width_sd*5, self.scrollView.height_sd);
        [self.scrollView setupAutoContentSizeWithRightView:self.membersTableView rightMargin:0];
        
        //浮动视图移动到最上层
//        [self bringSubviewToFront:_studentCameraView];
        
    }
    return self;
}

#pragma mark- get method

-(NTESMeetingActorsView *)teacherCameraView{
    
    if (!_teacherCameraView) {
        _teacherCameraView = [[NTESMeetingActorsView alloc]init];
        _teacherCameraView.frame = CGRectMake(0, 0, self.width_sd, self.width_sd/16*9);
//        _teacherCameraView.canMove = NO;
        [_teacherCameraView makePlaceHolderImage:[UIImage imageNamed:@"PlayerHolder"]];
    }
    
    return _teacherCameraView;
}

-(UIControl *)cameraOverlay{
    
    if (!_cameraOverlay) {
        _cameraOverlay = [[UIControl alloc]init];
        
        [_cameraOverlay addTarget:self action:@selector(changeOverlay:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cameraOverlay;
    
}


//-(IJKFloatingView *)studentCameraView{
//    
//    if (!_studentCameraView) {
//        _studentCameraView = [[IJKFloatingView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd/2, self.width_sd/2/16*9)];
//        _studentCameraView.canMove = YES;
//        [_studentCameraView makePlaceHolderImage:[UIImage imageNamed:@"PlayerHolder"]];
//        
//    }
//    return _studentCameraView;
//}

-(InteractionControl *)topControl{
    
    if (!_topControl) {
        _topControl = [[InteractionControl alloc]init];
    }
    return _topControl;
}

-(HMSegmentedControl *)segmentControl{
    
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"白板",@"聊天",@"公告",@"详情",@"成员"] ];
        
        _segmentControl.borderType = HMSegmentedControlBorderTypeBottom;
        _segmentControl.borderWidth = 1;
        _segmentControl.borderColor = SEPERATELINECOLOR;
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13*ScrenScale]};
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName:TITLECOLOR};
        _segmentControl.selectionIndicatorColor = NAVIGATIONRED;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.borderType = HMSegmentedControlTypeText;
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentControl.selectionIndicatorHeight = 2;
        
        UIView *line = [[UIView alloc ]init];
        [_segmentControl addSubview:line];
        line.sd_layout
        .leftEqualToView(_segmentControl)
        .rightEqualToView(_segmentControl)
        .bottomEqualToView(_segmentControl)
        .heightIs(0.8);
        line.backgroundColor = SEPERATELINECOLOR_2;
        
    }
      return _segmentControl;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        
    }
    return _scrollView;
}

-(UIView *)whiteBoardView{
    
    if (!_whiteBoardView) {
        _whiteBoardView = [[UIView alloc]init];
        _whiteBoardView.backgroundColor = [UIColor whiteColor];
        
    }
    return _whiteBoardView;
    
}

-(UIView *)chatView{
    
    if (!_chatView) {
        
        _chatView = [[UIView alloc]init];
        
    }
    return _chatView;
}
-(UITableView *)chatTableView{
    
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]init];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _chatTableView;
    
}

-(UITableView *)noticeTableView{
    if (!_noticeTableView) {
        _noticeTableView = [[UITableView alloc]init];
        _noticeTableView.tableFooterView = [UIView new];
        
    }
    return _noticeTableView;
}

-(UITableView *)classListTableView{
    if (!_classListTableView) {
        _classListTableView = [[UITableView alloc]init];
        _classListTableView.tableFooterView = [UIView new];
        
    }
    return _classListTableView;
}

-(InteractionInfoView *)classInfoView{
    
    if (!_classInfoView) {
        _classInfoView =[[InteractionInfoView alloc]init];
    
    }
    return _classInfoView;
}


-(UITableView *)membersTableView{
    
    if (!_membersTableView) {
        _membersTableView = [[UITableView alloc]init];
        _membersTableView.tableFooterView = [UIView new];
        
    }
    return _membersTableView;
}


#pragma mark- delegate method

- (void)changeOverlay:(UIControl *)sender{
    
    [_delegate controlOnOverlay:sender];
    
}


@end
