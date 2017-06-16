//
//  AllTeachersViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllteachersFilterView.h"

@interface AllTeachersViewController : UIViewController

@property (nonatomic, strong) AllteachersFilterView *filterView ;

@property (nonatomic, strong) UITableView *mainView ;

@property (nonatomic, strong) UICollectionView *subjectFilterView ;


@end
