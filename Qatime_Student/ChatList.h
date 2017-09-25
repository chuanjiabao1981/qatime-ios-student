//
//  ChatList.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/20.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TutoriumList.h"
#import "InteractiveCourse.h"
#import "ExclusiveInfo.h"

@interface ChatList : NSObject
/**辅导班名称*/
@property(nonatomic,strong) NSString *name ;
/**新消息数量*/
@property(nonatomic,assign) NSInteger badge ;
/**辅导班*/
@property(nonatomic,strong) TutoriumListInfo *tutorium ;

/**一对一 */
@property (nonatomic, strong) InteractiveCourse *interaction ;

@property (nonatomic, strong) ExclusiveInfo *exclusive ;

/**收到最后一条消息的时间*/
@property (nonatomic, assign) NSTimeInterval lastTime ;

@property (nonatomic, assign) CourseType classType;

@end
