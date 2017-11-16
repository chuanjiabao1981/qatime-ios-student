//
//  ExclusiveInfo_ClassListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TutoriumInfo_ClassListViewController.h"

typedef void(^ClickedReplay)(UITableView *tableView, NSIndexPath *indexPath);

@interface ExclusiveInfo_ClassListViewController : UITableViewController
//回放的回调
@property (nonatomic, copy) ClickedReplay replayBlock ;

/**
 重写初始化器,传两个参数,先杀线下两个课程数组

 @param onlineClasses 线上课程
 @param offlineClasses 线下课程
 @return id
 */
-(instancetype)initWithOnlineClass:(__kindof NSArray *)onlineClasses andOfflineClass:(__kindof NSArray *)offlineClasses bought:(BOOL)bought;

@end
