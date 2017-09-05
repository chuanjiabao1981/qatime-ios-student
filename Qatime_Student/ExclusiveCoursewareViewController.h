//
//  ExclusiveCoursewareViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExclusiveCoursewareViewController : UIViewController

@property (nonatomic, strong) UITableView *mainView ;

-(instancetype)initWithClassID:(NSString *)classID;

@end
