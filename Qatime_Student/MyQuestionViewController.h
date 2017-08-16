//
//  MyQuestionViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyQuestionView.h"

#import "MyQuestion_UnresolvedViewController.h"
#import "MyQuestion_ResolvedViewController.h"

@interface MyQuestionViewController : UIViewController

@property (nonatomic, strong) MyQuestionView *mainView ;

@property (nonatomic, strong) MyQuestion_UnresolvedViewController *unresolvedController ;

@property (nonatomic, strong) MyQuestion_ResolvedViewController *resolvedController ;

@end
