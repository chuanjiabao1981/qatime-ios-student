//
//  TeachersPublicViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachersPublicHeaderView.h"
#import "TeachersPublicCollectionView.h"

@interface TeachersPublicViewController : UIViewController

/**教师课程列表页*/
@property(nonatomic,strong) TeachersPublicCollectionView *teachersPublicCollectionView ;
/**教师ID*/
@property(nonatomic,strong) NSString *teacherID ;

/**
 传入教师id,访问教师信息

 @param teacherID 教师id
 @return 对象
 */
- (instancetype)initWithTeacherID:(NSString *)teacherID;

@end
