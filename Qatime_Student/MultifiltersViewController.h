//
//  MultifiltersViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

//  多项筛选页面

#import <UIKit/UIKit.h>
#import "MultiFiltersView.h"
#import "HcdDateTimePickerView.h"

/**
 回调

 @param changed 是否修改了数据
 */
typedef void(^multiFilters)(BOOL changed);


@interface MultifiltersViewController : UIViewController


/**
 主要项目筛选页面
 */
@property (nonatomic, strong) MultiFiltersView *multiFiltersView ;

@property (nonatomic, strong) UIView *timeView ;

@property (nonatomic, strong) UIButton *startTime ;

@property (nonatomic, strong) UIButton *endTime ;

/**
 立即筛选 按钮
 */
@property (nonatomic, strong) UIButton *filterButton ;


/**
 回调数据
 */
@property (nonatomic, copy) multiFilters componentsBlock ;


- (void)multiFilters:(multiFilters)changed ;


@end
