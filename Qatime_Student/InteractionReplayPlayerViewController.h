//
//  InteractionReplayPlayerViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "InteractionReplayLesson.h"
#import "InteractionReplayLessonsTableViewCell.h"

@interface InteractionReplayPlayerViewController : VideoPlayerViewController

@property (nonatomic, strong) UITableView *lessonList ;

@property (nonatomic, strong) UIButton *lessonListBtn ;

@property (nonatomic, strong) NSArray *replayArray ;

@property (nonatomic, strong) NSMutableArray *replayLessonsArray ;

- (id)initWithURL:(NSURL *)url  andTitle:(NSString *)title andReplayArray:(NSArray *)replaysArray andPlayingIndex:(NSIndexPath *)indexPath;


@end

