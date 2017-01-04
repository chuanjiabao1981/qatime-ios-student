//
//  UIButton+EnlargeTouchArea.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdge:(CGFloat)size;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
