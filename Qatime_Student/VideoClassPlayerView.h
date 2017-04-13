//
//  VideoClassPlayerView.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "VideoClass_Player_InfoView.h"
#import "VideoClassInfo.h"

@interface VideoClassPlayerView : UIView

/**滑动控制器*/
@property (nonatomic, strong) HMSegmentedControl *segmentControl ;

/**大滑动视图*/
@property (nonatomic, strong) UIScrollView *scrollView ;

/**视频列表*/
@property (nonatomic, strong) UITableView *classVideoListTableView ;

/**详情图*/
@property (nonatomic, strong) VideoClass_Player_InfoView *infoView ;

/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;


@end
