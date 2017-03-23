//
//  VideoInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "InfoHeaderView.h"


@interface VideoInfoView : UIView

/* 滑动选择器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl;

/* 大滑动视图*/
@property(nonatomic,strong) UIScrollView *scrollView;

/**view1 放课程公告*/
@property (nonatomic, strong) UIView *view1 ;

/* 单独提出View2 放置聊天页面*/
@property(nonatomic,strong) UIView *view2 ;

/* 单独提出view3*/
@property(nonatomic,strong) UIView *view3 ;

/* 单独提出view4 放置在线成员*/
@property(nonatomic,strong) UIView *view4 ;




@end
