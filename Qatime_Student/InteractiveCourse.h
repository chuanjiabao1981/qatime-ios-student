//
//  InteractiveCourse.h
//  Qatime_Student
//
//  Created by Shin on 2017/5/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractiveCourse : NSObject

@property (nonatomic, strong) NSString *classID ;
@property (nonatomic, strong) NSString *name ;
@property (nonatomic, strong) NSString *subject ;
@property (nonatomic, strong) NSString *grade ;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, strong) NSString *descriptions ;
/**增加一个富文本描述属性*/
@property (nonatomic, strong) NSMutableAttributedString *attributedDescription ;
@property (nonatomic, assign) NSInteger lessons_count ;
@property (nonatomic, assign) NSInteger completed_lessons_count ;
@property (nonatomic, assign) NSInteger closed_lessons_count ;
@property (nonatomic, assign) NSInteger started_lessons_count ;
@property (nonatomic, strong) NSString *live_start_time ;
@property (nonatomic, strong) NSString *live_end_time ;
@property (nonatomic, strong) NSString *objective ;
@property (nonatomic, strong) NSString *suit_crowd ;
@property (nonatomic, strong) NSString *teacher_percentage ;
@property (nonatomic, strong) NSArray *teachers ;
@property (nonatomic, strong) NSDictionary *publicize ;
@property (nonatomic, strong) NSDictionary *icons ;
@property (nonatomic, assign) BOOL off_shelve ;


/**专门为聊天功能增加一个notify属性*/
@property (nonatomic, assign) BOOL notify ;
/**专门为聊天功能增加一个chat_team_id属性*/
@property (nonatomic, strong) NSString *chat_team_id ;


@end
