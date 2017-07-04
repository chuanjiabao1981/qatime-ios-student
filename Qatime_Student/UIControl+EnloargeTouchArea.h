//
//  UIControl+EnloargeTouchArea.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/4.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (EnloargeTouchArea)

- (void)setEnlargeEdge:(CGFloat)size;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
