//
//  UIView+PlaceholderImage.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/29.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PlaceholderImage)

/**
 占位图
 */
@property (nonatomic, strong) UIImageView * _Nullable placeholderImage ;



/**
 给UIView增加一个占位图的方法

 @param image 图片,传nil则为去掉占位图.
 */
- (void)makePlaceHolderImage:(UIImage * _Nullable)image;


@end
