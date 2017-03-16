//
//  ClassFilterView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//
//  条件筛选框

#import <UIKit/UIKit.h>

@interface ClassFilterView : UIView

/**
 最新按钮
 */
@property (nonatomic, strong) UIButton *newestButton;

/**
 价格按钮
 */
@property (nonatomic, strong) UIButton *priceButton;

/**
 人气按钮
 */
@property (nonatomic, strong) UIButton *popularityButton ;

/**
 标签按钮
 */
@property (nonatomic, strong) UIButton *tagsButton ;

/**
 条件筛选按钮
 */
@property (nonatomic, strong) UIControl *filterButton ;

@end
