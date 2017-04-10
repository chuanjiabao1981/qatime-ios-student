//
//  LiveClassFilterViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OneOnOneClass.h"
#import "TutoriumList.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "UIViewController+HUD.h"
#import "ChooseClassTableViewCell.h"
#import "TutoriumInfoViewController.h"
#import "HaveNoClassView.h"

@interface LiveClassFilterViewController : UIViewController

@property (nonatomic, strong) UITableView *classTableView ;

/**
 初始化方法

 @param grade 年级
 @param subject 科目
 @param course 筛选字段
 @return id
 */
- (instancetype)initWithGrade:(NSString *)grade andSubject:(NSString *)subject andCourse:(NSString *)course;


/**
 筛选方法

 @param filterdDic 传入筛选字典(字段)
 */
- (void)filterdByFilterDic:( __kindof NSMutableDictionary *)filterdDic;

/**
 标签筛选方法
 
 @param tag 标签字段
 */
- (void)filteredByTages:(NSString *)tag;

@end
