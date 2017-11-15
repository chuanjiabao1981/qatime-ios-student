//
//  VideoClassInfo_ClassListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClass.h"

@interface VideoClassInfo_ClassListViewController : UITableViewController


-(instancetype)initWithClasses:(__kindof NSArray <VideoClass *>*)classArray bought:(BOOL)bought;
@end
