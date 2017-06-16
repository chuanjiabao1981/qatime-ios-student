//
//  SearchingTeachersTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachersSearch.h"

@interface SearchingTeachersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage ;
@property (nonatomic, strong) UILabel *teacherName ;
@property (nonatomic, strong) UIButton *teachingYears ; //教龄用button是为了使用圆角边框自动布局
@property (nonatomic, strong) UILabel *teacherInfo ;
@property (nonatomic, strong) UIImageView *genderImage ;


@property (nonatomic, strong) TeachersSearch *model ;


@end
