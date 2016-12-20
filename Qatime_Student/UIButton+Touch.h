//
//  UIButton+Touch.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/20.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 2.0  //默认时间间隔  
@interface UIButton (Touch)

/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;

@end
