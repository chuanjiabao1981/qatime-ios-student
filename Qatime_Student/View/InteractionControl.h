//
//  InteractionControl.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/29.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InteractionControlDelegate <NSObject>

/**
 controller 返回上一页
 */
- (void)returnLastPage:(UIButton *)sender;

/**
 全屏缩放

 @param sender 点击的按钮
 */
- (void)scale:(UIButton *)sender;


/**
 开关摄像头

 @param sender 点击的按钮
 */
- (void)turnCamera:(UIButton *)sender;
- (void)onSelfVideoPressed:(UIButton *)sender;

/**
 开关声音

 @param sender 点击的按钮
 */
- (void)turnVoice:(UIButton *)sender;
- (void)onSelfAudioPressed:(id)sender;

@end


@interface InteractionControl : UIView

/**
 声音按钮
 */
@property (nonatomic, strong) UIButton *voiceButton ;

/**
 摄像头按钮
 */
@property (nonatomic, strong) UIButton *cameraButton ;

/**
 全屏切换按钮
 */
@property (nonatomic, strong) UIButton *scaleButton ;

/**
 title标题
 */
@property (nonatomic, strong) UILabel *titleLabel ;

/**
 返回上一页按钮
 */
@property (nonatomic, strong) UIButton *returnButton ;


/**
 控制方法代理
 */
@property (nonatomic, weak) id <InteractionControlDelegate> delegate ;


@end
