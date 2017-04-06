//
//  InteractionTeacherListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher.h"

@interface InteractionTeacherListTableViewCell : UITableViewCell

/**头像*/
@property (nonatomic, strong) UIImageView *headImage ;

/**姓名*/
@property (nonatomic, strong) UILabel *teacherName ;

/**性别图标*/
@property (nonatomic, strong) UIImageView *genderImage ;

/**工作地点*/
@property (nonatomic, strong) UILabel *school ;

/**教龄*/
@property (nonatomic, strong) UILabel *workYears ;

/**箭头*/
@property (nonatomic, strong) UIImageView *enterArrow ;


/**model*/
@property (nonatomic, strong) Teacher *model ;

@end
