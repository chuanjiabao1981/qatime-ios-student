//
//  VideoInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"


@interface VideoInfoView : UIView

/* 滑动选择器*/
@property(nonatomic,strong) HMSegmentedControl *segmentControl;

/* 大滑动视图*/
@property(nonatomic,strong) UIScrollView *scrollView;


/* 公告*/
@property(nonatomic,strong) UITableView  *noticeTabelView ;


/* <# State #>*/


@end
