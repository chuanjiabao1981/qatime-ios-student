//
//  SearchingClassesTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSearch.h"

@interface SearchingClassesTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *classImage ;
@property (nonatomic, strong) UILabel *className ;
@property (nonatomic, strong) UILabel *classInfo ;
@property (nonatomic, strong) UILabel *teacherName ;


@property (nonatomic, strong) ClassSearch *model;


@end
