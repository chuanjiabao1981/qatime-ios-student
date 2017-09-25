//
//  CourseFileTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseFile.h"

@interface CourseFileTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *fileImage ;
@property (nonatomic, strong) UILabel *name ;
@property (nonatomic, strong) UILabel *size ;
@property (nonatomic, strong) UILabel *info ;

@property (nonatomic, strong) CourseFile *model ;



@end
