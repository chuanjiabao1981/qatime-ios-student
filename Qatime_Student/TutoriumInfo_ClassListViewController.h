//
//  TutoriumInfo_ClassListViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumInfo_ClassListView.h"
#import "ClassesListTableViewCell.h"

//回放的回调
typedef void(^ClickReplay)(NSIndexPath *indexPath);

@interface TutoriumInfo_ClassListViewController : UIViewController

@property (nonatomic, strong) TutoriumInfo_ClassListView *mainView ;

@property (nonatomic, copy) ClickReplay clickedReplay ;

-(instancetype)initWithClasses:(__kindof NSArray *)classes bought:(BOOL)bought;


@end
