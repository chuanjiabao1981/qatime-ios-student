//
//  ChooseClassViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassFilterView.h"
#import "ChooseClassView.h"
#import "TagsFilterView.h"
#import "SnailQuickMaskPopups.h"

#import "LiveClassFilterViewController.h"
#import "InteractionClassFilterViewController.h"
#import "VideoClassFilterViewController.h"

typedef enum : NSUInteger {
    TutoriumSearchType,
    InteractionSearchType,
    
} SearchType;


@interface ChooseClassViewController : UIViewController

/**
 筛选课程列表视图
 */
@property (nonatomic, strong) ChooseClassView *chooseView ;

/**
 筛选工具栏
 */
@property (nonatomic, strong) ClassFilterView *filterView ;

/**
 课程列表
 */
//@property (nonatomic, strong) UITableView *classTableView ;


/**
 标签筛选列表
 */
@property (nonatomic, strong) TagsFilterView *tagsFilterView ;

/**三个子controller*/

/**直播课筛选controller*/
@property (nonatomic, strong) LiveClassFilterViewController *liveClassFilterController ;
/**一对一课筛选controller*/
@property (nonatomic, strong) InteractionClassFilterViewController  *interactionClassFilterController;
/**视频课筛选controller*/
@property (nonatomic, strong) VideoClassFilterViewController *videoClassFilterController ;


/**
 初始化

 @param grade 年级
 @param subject 科目
 @return 实例
 */
-(instancetype)initWithGrade:(NSString *)grade andSubject:(NSString *)subject;


/**获取所有标签*/
- (void)getTags;

@end
