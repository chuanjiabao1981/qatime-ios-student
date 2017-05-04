//
//  NoticeIndexView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/16.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "Qatime_Student-Swift.h"

@interface NoticeIndexView : UIView

/* 另一个滑动控制器....*/
@property(nonatomic,strong) JTSegmentControl *segmentControl ;

/* 滑动控制器*/
//@property(nonatomic,strong) HMSegmentedControl *segmentControl ;


/* 大滚动视图*/
@property(nonatomic,strong) UIScrollView  *scrollView ;

/* 聊天室列表*/
@property(nonatomic,strong) UITableView *chatListTableView ;

/* 消息列表*/
@property(nonatomic,strong) UITableView *noticeTableView ;

@end
