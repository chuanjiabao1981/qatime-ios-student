//
//  ProvinceHeaderView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceHeaderView : UIView

/**
 已选省份
 */
@property(nonatomic,strong) UILabel *chosenProvicne ;

/**
 已选城市
 */
@property(nonatomic,strong) UILabel *chosenCity ;

/**
 当前省份
 */
@property(nonatomic,strong) UILabel *currentProvince ;

/**
 当前城市
 */
@property(nonatomic,strong) UILabel *currentCity ;

@end
