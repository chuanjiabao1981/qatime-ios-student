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

//上滑 或 下拉
typedef enum : NSUInteger {
    PullToRefresh,      //下拉刷新
    PushToReadMore      //上滑加载更多
} RefreshMode;

@interface LiveClassFilterViewController : UIViewController

@property (nonatomic, strong) UITableView * _Nonnull classTableView ;

/**年级*/
@property (nonatomic, strong) NSString * _Nonnull grade ;
/**科目*/
@property (nonatomic, strong) NSString * _Nonnull subject ;

/**token*/
@property (nonatomic, strong) NSString * _Nonnull token;
@property (nonatomic, strong) NSString * _Nonnull idNumber;

//加载课程页数
@property (nonatomic, assign) NSInteger page;
//每页条数
@property (nonatomic, assign) NSInteger perPage;

//存课程数据的数组
@property (nonatomic, strong) NSMutableArray * _Nonnull classesArray;

//筛选用的字典
@property (nonatomic, strong) NSMutableDictionary * _Nonnull filterDic;

//是否为初始化下拉
@property (nonatomic, assign) BOOL isInitPull;

//接口字段
@property (nonatomic, strong) NSString * _Nonnull course;

/**
 初始化方法

 @param grade 年级
 @param subject 科目
 @param course 筛选字段
 @return id
 */
- (instancetype _Nullable )initWithGrade:(NSString *_Nullable)grade andSubject:(NSString *_Nullable)subject andCourse:(NSString *_Nullable)course;


/**
 筛选方法

 @param filterdDic 传入筛选字典(字段)
 */
- (void)filterdByFilterDic:( __kindof NSMutableDictionary *_Nullable)filterdDic;

/**
 标签筛选方法
 
 @param tag 标签字段
 */
- (void)filteredByTages:(NSString *_Nullable)tag;


/**
 请求数据方法,公开是为了子类可以重写

 @param mode 刷新方式
 @param contentDic 请求数据的content字典
 */
- (void)requestClass:(RefreshMode)mode withContentDictionary:( nullable __kindof NSDictionary * )contentDic;

@end
