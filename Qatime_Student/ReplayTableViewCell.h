//
//  ReplayTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplayLesson.h"

@interface ReplayTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *classImage ;

@property (nonatomic, strong) UILabel *className ;

@property (nonatomic, strong) UILabel *classInfo ;

@property (nonatomic, strong) UILabel *counts ;

@property (nonatomic, strong) UIImageView *sights ;

@property (nonatomic, strong) ReplayLesson *model ;

@end
