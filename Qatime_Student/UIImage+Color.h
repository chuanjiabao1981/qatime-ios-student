//
//  UIImage+Color.h
//  Qatime_Student
//
//  Created by Shin on 2017/5/23.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
/**
 *  @brief  根据颜色生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
