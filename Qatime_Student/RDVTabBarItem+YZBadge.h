//
//  RDVTabBarItem+YZBadge.h
//  Qatime_Student
//
//  Created by Shin on 2017/2/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>  
#import "RDVTabbarItem.h"


@interface RDVTabBarItem (YZBadge)

@property(nonatomic,strong) UIView *badge ;

@property(nonatomic,assign) BOOL isShowNow ;


/**
 绘制一个badge而已,用于显示消息
 */
- (void)showBadges;


/**
 隐藏badge
 */
- (void)hideBadges;

@end
