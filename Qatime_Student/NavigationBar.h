//
//  NavigationBar.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//



/* 导航栏*/

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /* 默认绿色*/
    DefaultColor,
    /* 可选红色*/
    RedColor,
    
} BackgroundColorType;

@interface NavigationBar : UIView
@property(nonatomic,strong) UIButton *leftButton ;
@property(nonatomic,strong) UIButton *rightButton ;
@property(nonatomic,strong) UILabel *titleLabel  ;

@property(nonatomic,assign) BackgroundColorType colorType ;



+ (instancetype)navigationBarWithFrame:(CGRect)frame title:(NSString *)title ;


@end
