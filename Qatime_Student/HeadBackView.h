//
//  HeadBackView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadBackView : UIView


/**
 背景图
 */
@property(nonatomic,strong) UIView *backGroundView ;



/**
 用户头像
 */
@property(nonatomic,strong) UIImageView *headImageView ;


/* 用户名*/

@property(nonatomic,strong) UILabel *name ;

@end
