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

 @param component 回调数据
 */
typedef void(^multiFilters)(NSMutableDictionary *component ,BOOL reset);


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


/**
 已筛选的条件

 @param filterdDic 筛选条件字典
 @return 实例
 */
-(instancetype)initWithFilters:( NSDictionary * _Nullable )filterdDic;

- (void)multiFilters:(multiFilters)components ;


@end
