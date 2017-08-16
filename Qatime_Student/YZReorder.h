//
//  YZReorder.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSlider.h"

@interface YZReorder : UIViewController

@property (nonatomic, strong) UIView *recordView ;

/** 录音右侧按钮 / 根据录音状态,可变 */
@property (nonatomic, strong) UIButton *rightBtn ;

@property (nonatomic, strong) UIButton *playBtn ;

/** 音频播放时候的滑竿 */
@property (nonatomic, strong) YZSlider *slider ;

/** 时间 */
@property (nonatomic, strong) UILabel *secend ;


@end
