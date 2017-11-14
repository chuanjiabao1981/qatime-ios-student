//
//  InteractiveInfo_InfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveInfo_InfoView.h"
#import "InteractiveInfo_InfoHeadView.h"
#import "InteractiveInfo_InfoFootView.h"

@interface InteractiveInfo_InfoViewController : UIViewController

@property (nonatomic, strong) InteractiveInfo_InfoView *mainView ;
@property (nonatomic, strong) InteractiveInfo_InfoHeadView *headView ;
@property (nonatomic, strong) InteractiveInfo_InfoFootView *footView ;

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

-(instancetype)initWithOneOnOneClass:(OneOnOneClass *)oneOnOneClass;

@end
