//
//  SqureMenu.h
//  YZSquareMenu
//
//  Created by Shin on 2016/9/28.
//  Copyright © 2016年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>

/* icon的形状*/
typedef NS_ENUM(NSInteger,YZMenuIconType) {
    
    /* 不规则形状/方形 的icon*/
    YZMenuIconTypeNone = 0,
    
    /* 圆形icon，传入方形图片会裁剪成圆形 默认*/
    YZMenuIconTypeRound ,
    
    /* 圆角矩形*/
    YZMenuIconTypeCornerRound,
    
};

/* 分割线类型*/
typedef NS_ENUM(NSUInteger,YZMenuBreaklineStyle) {
   
    /* 无分割线 默认*/
    YZMenuBreaklineStyleNone = 0,
    
    /* 有下划线*/
    YZMenuBreaklineStyleBottom ,
    
    /* 全线 */
    
    YZMenuBreaklineStyleAll ,
    
    
};

/* 横轴分割线长度*/
typedef NS_ENUM(NSUInteger,YZBreaklineWidthStyle) {
    
    /* 和构件长度一样 默认值*/
    YZBreaklineWidthIcon =0,
    
    /* 和item的长度一样*/
    YZBreaklineWidthItem ,
    
    
};


@protocol YZSquareMenuDelegate <NSObject>

/* 监测用户点击的图标index*/
- (void)touchesIconIndex:(NSInteger)index;

@end


@interface YZSquareMenu : UIView

@property(nonatomic,strong) UICollectionView *collectionMenu ;

/* 在使用时，传入图标名、title两个数组*/
@property(nonatomic,strong) NSArray *menuIconName ;
@property(nonatomic,strong) NSArray *menuIconTitle ;
/* 选择图标的形状，圆形和默认两种，默认为方形*/
@property(nonatomic,assign) YZMenuIconType iconType ;
/* 线条种类，若选择无线外的任何类型，都要设置线条颜色和线宽*/
@property(nonatomic,assign) YZMenuBreaklineStyle breaklineStyle ;

/* 横轴分割线长度*/
@property(nonatomic,assign) YZBreaklineWidthStyle breaklineWidthStyle ;
/* 线条颜色*/
@property(nonatomic,strong) UIColor *breaklineColor ;
/* 线宽*/
@property(nonatomic,assign) CGFloat lineWidth ;


/* 图标数量*/
@property(nonatomic,assign) NSInteger iconNumbers ;

/* 代理属性*/
@property(nonatomic,weak) id <YZSquareMenuDelegate> YZSquareMenuDelegate ;


/* 初始化器1 一个方法涵盖所有属性*/
- (instancetype)initWithFrame:(CGRect)frame
                  iconNumbers:(NSInteger)iconNumber
                 menuIconName:(NSArray *)menuIconName
                menuIconTitle:(NSArray *)menuIconTitle
                     iconType:(YZMenuIconType *)iconType
               breaklineStyle:(YZMenuBreaklineStyle *)breaklineStyle
          breaklineWidthStyle:(YZBreaklineWidthStyle *)breaklineWidthStyle
               breaklineColor:(UIColor *)breaklineColor
                    lineWidth:(CGFloat)lineWidth;

/* 初始化器2 一个方法调用图标和标题 参数为默认值*/
- (instancetype)initWithFrame:(CGRect)frame
                  iconNumbers:(NSInteger)iconNumber
                 menuIconName:(NSArray *)menuIconName
                menuIconTitle:(NSArray *)menuIconTitle
                     iconType:(YZMenuIconType *)iconType;





@end


/* collection的cell设置*/


