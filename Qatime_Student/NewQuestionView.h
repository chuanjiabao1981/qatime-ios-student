//
//  NewQuestionView.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSlider.h"
#import "YZReorder.h"

@interface NewQuestionView : UIScrollView

@property (nonatomic, strong) UITextField *title ;

@property (nonatomic, strong) UITextView *questions ;

@property (nonatomic, strong) UICollectionView *photosView ;

//@property (nonatomic, strong) UIView *recordView ;

///** 录音右侧按钮 / 根据录音状态,可变 */
//@property (nonatomic, strong) UIButton *rightBtn ;
//
//@property (nonatomic, strong) UIButton *playBtn ;
//
///** 音频播放时候的滑竿 */
//@property (nonatomic, strong) YZSlider *slider ;
//
///** 时间 */
//@property (nonatomic, strong) UILabel *secend ;

@property (nonatomic, strong) YZReorder *recorder ;

@end
