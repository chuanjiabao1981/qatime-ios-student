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

#import "ZLPhoto.h"
@protocol PhotoBrowserDelegate

- (void)showPicker:(ZLPhotoPickerBrowserViewController*)picker;

@end

@interface HomeworkInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *index ;

@property (nonatomic, strong) UILabel *title ;

/** 状态按钮,有时候也做提示按钮 */
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

@property (nonatomic, strong) UICollectionView *correctPhotosView ;
@property (nonatomic, strong) YZReorder *correctRecorder ;

@property (nonatomic, weak) id<PhotoBrowserDelegate> photoDelegate ;

@end
