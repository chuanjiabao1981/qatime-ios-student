//
//  AllClassViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/28.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllClassView.h"

#import "HaveNoClassView.h"
@interface AllClassViewController : UIViewController

@property(nonatomic,strong) AllClassView *allClassView ;

@property(nonatomic,strong) UITableView *classTableView ;


@property(nonatomic,strong) HaveNoClassView *haveNoClassView ;

@end
