//
//  TutoriumViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "TutoriumView.h"
#import "TutoriumList.h"
#import "MultiFilterView.h"

@interface TutoriumViewController : UIViewController

@property(nonatomic,strong) NavigationBar *navigationBar ;

@property(nonatomic,strong) TutoriumView *tutoriumView ;

@property(nonatomic,strong) MultiFilterView *multiFilterView ;




@end
