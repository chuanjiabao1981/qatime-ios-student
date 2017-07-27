//
//  MyExclusiveClassCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/7/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTutoriumModel.h"

typedef NS_ENUM(NSUInteger, ClassType) {
    PublisedClass,
    TeachingClass,
    CompletedClass,
};

@interface MyExclusiveClassCell : UITableViewCell

/**课程图片*/
@property(nonatomic,strong) UIImageView *classImage ;

/**课程名称*/
@property(nonatomic,strong) UILabel *className ;
/** 课程辅名 */
@property (nonatomic, strong) UILabel *classInfo ;

/** 状态*/
@property(nonatomic,strong) UILabel *status ;

/** 进入按钮*/
//@property(nonatomic,strong) UIButton *enterButton ;

/** 外框content*/
@property(nonatomic,strong) UIView *content;

@property (nonatomic, assign) ClassType classType ;

/* 数据model*/
@property(nonatomic,strong) MyTutoriumModel *model ;




@end
