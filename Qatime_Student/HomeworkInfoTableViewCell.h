//
//  HomeworkInfoTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkInfo.h"
#import "YZReorder.h"

@interface HomeworkInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *index ;

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *status ;

@property (nonatomic, strong) YZReorder *homeworkRecorder ;
@property (nonatomic, strong) UICollectionView *homeworkPhotosView ;
//我的答案
@property (nonatomic, strong) UILabel *answerTitle ;
@property (nonatomic, strong) YZReorder *answerRecorder ;
@property (nonatomic, strong) UICollectionView *answerPhotosView ;

//老师批改
@property (nonatomic, strong) UILabel *teacherCheckTitle ;

@property (nonatomic, strong) HomeworkInfo *model ;

@property (nonatomic, assign) BOOL havePhotos ;
@property (nonatomic, assign) BOOL haveRecord ;

@property (nonatomic, assign) BOOL haveAnswerPhotos ;
@property (nonatomic, assign) BOOL haveAnswerRecord ;

@property (nonatomic, assign) BOOL haveCorrectPhotos ;
@property (nonatomic, assign) BOOL haveCorrectRecord ;


@end
