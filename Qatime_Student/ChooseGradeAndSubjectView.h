//
//  ChooseGradeAndSubjectView.h
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGradeAndSubjectDelegate.h"

@interface ChooseGradeAndSubjectView : UIView <ChooseGradeAndSubjectDelegate>

@property (nonatomic, strong) UIView *gradeView ;

@property (nonatomic, strong) UIView *subjectView ;

@property (nonatomic, strong) UICollectionView *subjectCollection ;

@property (nonatomic, weak) id <ChooseGradeAndSubjectDelegate>delegate ;

@property (nonatomic, strong) NSMutableArray <UIButton *>*gradeButtons ;


@end
