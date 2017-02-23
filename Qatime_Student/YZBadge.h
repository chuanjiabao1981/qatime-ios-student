//
//  YZBadge.h
//  Qatime_Student
//
//  Created by Shin on 2017/2/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface YZBadge : UILabel

//badge上显示的数字
@property(nonatomic,assign) NSInteger badgeNumber ;

//badge的最大数字(超过该数字 直接显示***+)
@property(nonatomic,assign) NSInteger maxBadgeNumber ;


+(instancetype)showBadgeWithNumber:(NSInteger)number ;

@end
