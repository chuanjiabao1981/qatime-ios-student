//
//  TutoriumInfo_InfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumInfo_InfoView.h"
#import "TutoriumInfo_InfoMainHeadView.h"
#import "TutoriumInfo_InfoMainFootView.h"
#import "WorkFlowCollectionViewCell.h"
#import "ClassFeaturesCollectionViewCell.h"
#import "TutoriumList.h"

@interface TutoriumInfo_InfoViewController : UIViewController

@property (nonatomic, strong) TutoriumInfo_InfoView *mainView ;

@property (nonatomic, strong) TutoriumInfo_InfoMainHeadView *headView ;

@property (nonatomic, strong) TutoriumInfo_InfoMainFootView *footView ;

////
//其他属性了
/** 课程特色的datasource */
@property (nonatomic, strong) NSArray *classfeatures ;
/** 学习流程的datasource */
@property (nonatomic, strong) NSArray *workflows ;
/** 头视图的尺寸 */
@property (nonatomic, assign) CGSize headSize ;
/** 脚视图的尺寸 */
@property (nonatomic, assign) CGSize footSize ;

-(instancetype)initWithTutorium:(TutoriumListInfo *)tutorium ;


@end
