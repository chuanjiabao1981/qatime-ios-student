//
//  ExclusiveInfo_InfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TutoriumInfo_InfoViewController.h"
#import "ExclusiveInfo_InfoHeadView.h"
#import "ExclusiveInfo_InfoFootView.h"

@interface ExclusiveInfo_InfoViewController : UICollectionViewController

@property (nonatomic, strong) ExclusiveInfo_InfoHeadView *headView ;
@property (nonatomic, strong) ExclusiveInfo_InfoFootView *footView ;


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

-(instancetype)initWithExclusiveClass:(ExclusiveInfo *)exclusiveInfo ;


@end
